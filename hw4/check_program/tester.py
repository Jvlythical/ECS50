#!/opt/python3/bin/python3

#this is the base class for tester objects
import subprocess
import logging
import os
from time import clock
from result import Result
import sys

studentLogger = logging.getLogger('errorLogger.progressLogger.studentLogger')

class Tester(object):
  """
  Tester
  abstract class representing a testing interface
  """
  __name__ = 'Tester' #the name of this class

  INPUT_STDIN = 1 #input is expected to come via standard input
  INPUT_CMDLINE = 2 #input is expected to comve via the command line
  OUTPUT_STDOUT = 3 #output of executable will be to the standard output
  OUTPUT_FILE = 4  #exectuables output will be a file

  _PROGRAM_COMPLETED = 5 #the program completed the test
  _PROGRAM_CRASHED = 6 #the program crashed during a test
  _PROGRAM_TIMED_OUT = 7 #the program timed out during a test

  def str2InputType(typename):
    """converts the string name of the input type to the internal type
    @typename: the name of the type. either
      stdin
      cmdline
    """
    if(typename.lower() == 'stdin'):
      return Tester.INPUT_STDIN
    elif(typename.lower() == 'cmdline'):
      return Tester.INPUT_CMDLINE
    else:
      raise ValueError('Unknown input type ' + typename)

  def str2OutputType(typename):
    """converts the string name of the output type to the internal type
    @typename: the name of the type. either
      stdout
      file
    """
    if(typename.lower() == 'stdout'):
      return Tester.OUTPUT_STDOUT
    elif(typename.lower() == 'file'):
      return Tester.OUTPUT_FILE
    else:
      raise ValueError('Unknown input type ' + typename)
    
  
  def __init__(self, executable, inputType, outputType, inDir, solDir, scratchDir, maxRunTime = 5, cmdArgs = None, lines2skip = 0):
    """
    @executable: the name of the exectuable to be run
    @inputOutput: how are inputs to be received. Either
      INPUT_STDIN for input comming from the standard input or
      INPUT_CMDLINE for input comming from the command line
    @outputType: how are outputs generated: Either
      OUTPUT_STDOUT: for when the solution is sent to standard out or
      OUTPUT_FILE: for when the solution is sent to a file
    @inDir: the name of the directory containing the inputs to be used for testing
      the naming convention for the tests contained within is testname-test.filetype
    @solDir: the name of the directory containing the solutions
      the naming convention for the solutions contained within is testname-sol.filetype
    @scratchDir: directory to write scratch files in
    @maxRunTime: the maximum number of seconds to run the program or
      None to allow the program to run until completion (if it does not terminate the program will hang)
    @cmdArgs: a list of additional command line arguments to the executbale
    @lines2skip: number of lines of output program and solution file to skip
    """


    self.executable = executable
    self.inputType = inputType
    self.outputType = outputType
    self.inDir = inDir
    self.solDir = solDir
    self.scratchDir = scratchDir
    self.maxRunTime = maxRunTime
    self.lines2skip = lines2skip
    if cmdArgs == None:
      self.cmdArgs = []
    else:
      self.cmdArgs = cmdArgs

    self.testFiles = [self.inDir + os.sep +
                      test for test in os.listdir(inDir)] #get the tests in the test directory
    self.testFiles.sort() #make the tests sorted

    if(scratchDir == None):
      self.userOut = None
    else:
      self.userOut = scratchDir + os.sep + 'userOut.txt' #file to temporarily store the use's output
    
    self.startTime = 0 #when did the test begin running
    self.endTime = 0   #when did the test end running
    
    self.results = [] #the results of the testing

  def _runOne(self, inFileName, outFileName = None):
    """run self.executable using the inputs contained in inFileName
       @inFileName: the name of the file containing the inputs
       @outFileName: the name of the file to write the program's stdout to if the solution is contained in the stdout
       @returns: the success status of running the program
       """
    #determine how to pass input file
    infile = None #the input file to be used
    additionalArgs = []
    if(self.inputType == Tester.INPUT_STDIN): #input expected from stdin
      infile = open(inFileName) #just open the file for redirection
    elif(self.inputType == Tester.INPUT_CMDLINE): #input expected from command line
      with open(inFileName) as args: 
        for arg in args: #read in the command line parameter
          additionalArgs.append(arg.strip())#each parameter is on a different line
    else:
      raise NotImplementedError

    #determine how outputs will be generated
    outfile = None
    if(self.outputType == Tester.OUTPUT_STDOUT): #outputting to stdout
      outfile = open(outFileName,'w') #open a file to hold the results
    elif(self.outputType == Tester.OUTPUT_FILE): #outputting to a file
      pass #nothing we can really do as of now
    else:
      raise NotImplementedError

    
    studentLogger.info('Preparing to test %s on %s', self.executable, os.path.basename(inFileName))

    #start the clocks
    self.endTime = clock()
    self.startTime = clock()

    #run the program
    with subprocess.Popen([self.executable] + self.cmdArgs + additionalArgs,
                          stdin = infile,
                          stdout = subprocess.PIPE,
                          stderr = subprocess.PIPE,
                          universal_newlines = True) as program:
      try:
        (out,err) = program.communicate(timeout = self.maxRunTime) #wait for the program to finish
        out = out.split('\n')
        #print('OUTPUT=',out.split('\n'))
        self.endTime = clock() #program completed
        #err = '\t'.join(program.stderr.readlines()) #always have to read the pipes
        if(program.returncode != 0):
          studentLogger.warning('%s %s crashed for the following reasons:\n\t%s\n',
                                self.executable, ' '.join(self.cmdArgs), err)
          return (Tester._PROGRAM_CRASHED, None)
        else:
          return (Tester._PROGRAM_COMPLETED, out)
          
      except subprocess.TimeoutExpired:
        studentLogger.warning('%s %s timed out', ' '.join(self.cmdArgs), self.executable)
        program.kill()
        return (Tester._PROGRAM_TIMED_OUT, None)
        
      finally: #close opened files
        if(infile != None):
          infile.close()
        if(outfile != None):
          #outfile.flush()
          #os.fsync(outfile.fileno())
          outfile.close()
      
  #end _runOne

  def testOne(self, inFile, solFile):
    """
    run the executable using inFile as the inputs
    and checking the output against solFile
    @inFIle: the name of the file containing the inputs
    @solFile: the name of the file containg the solution
    @returns: a Result
    """
    (progStatus, studentAnswer) = self._runOne(inFile, self.userOut)#run the program
    testName = os.path.basename(inFile) #the name of the test
    if(progStatus == Tester._PROGRAM_CRASHED):
      return Result(testName, False, 'Crashed')
    elif(progStatus == Tester._PROGRAM_TIMED_OUT):
      return Result(testName, False, 'Timed Out')
    else: #program completed successfully
      if(self.outputType == Tester.OUTPUT_STDOUT):
        (correct, out, sol) = self._checkSolution(studentAnswer, solFile)
        if(correct):
          studentLogger.info('%s %s passed test %s',
                           self.executable, ' '.join(self.cmdArgs),
                           os.path.basename(inFile))
        else:
          studentLogger.info('%s %s failed test %s. Program output: %s \n Solution: %s \n\n',
                           self.executable, ' '.join(self.cmdArgs),
                           os.path.basename(inFile), out, sol)
        return Result(testName, correct, self.endTime - self.startTime )
      else: #haven't done anything where solutions are contained in files
        raise NotImplementedError
  #end testOne

  

  def generateSolutions(self):
    """generates all the solutions"""
    for test in self.testFiles:
      outfileName = test.replace('-test', '-sol')
      outfileName = self.solDir + os.sep + os.path.basename(outfileName)
      self._runOne(test,outfileName)
  #end generateSolutions

  def testAll(self):
    """
    Test all the tests
    @returns: a list of triples of the form (testName, correct, time taken)
    correct is True if the answer is correct and False if it is wrong
    time taken is expressed in seconds.

    See Result
    """

    self.results = [] #clear old results if any exist
    for test in self.testFiles:
      #get the name of the file containing the solution to this test
      sol = test.replace('-test', '-sol') #replace test with sol
      sol = self.solDir + os.sep + os.path.basename(sol) #prepend solution directory name and remove test directory path
      self.results.append(self.testOne(test, sol))
    try:
      os.remove(self.userOut)
    except FileNotFoundError:
      pass
  #end testAll

  def getResults(self):
    """get the results of the testing"""
    return self.results.copy()
  #end getResults
  
  def getNumTests(self):
    """get the number of tests that are to be preformed"""
    return len(self.testFiles)
  #end getNumTests

  def getNumCorrect(self):
    """
    get the number of answers that were correct
    should only be called after testAll is run
    @returns: the number of tests that were correct
    """
    numCorrect = 0
    for res in self.results:
      if(res.correct == True):
        numCorrect += 1
    return numCorrect
  #end getNumCorrect

  def getPercentCorrect(self):
    """get the precentage of right answers
    should only be called after testAll is run
    @returns: the percentage of tests that were correct
    """
    numCorrect = self.getNumCorrect()
    numTests = float(self.getNumTests())
    return numCorrect / numTests
  #end getPercentCorrect

  def getMissedTests(self):
    """
    get a list of the test names that were missed
    should only be called after testAll is run
    @returns: a list of the test names that were missed
    """
    return [res.testName for res in self.results if not res.correct]
  #end getMissedTests
  
  def getPassedTests(self):
    """
    get a list of the test names that were passed correctly
    should only be called after testAll is run
    @returns: a list of the test names that were passed correctly
    """
    return [res.testName for res in self.results if res.correct]
  #getPassedTests

  def getTestNames(self):
    """
    get the names of the tests to be run
    can be called before testAll is run
    @returns: a list containg the test names
    """
    return [test.rsplit(os.sep, 1)[-1] for test in self.testFiles]

  def _checkSolution(self, progOut, solutionFileName):
    """
    checkSolution
    @progOut: the opened file containing the student's answer
    @solutionFileName: the name of the file containg the solution
    @returns a tuple containing
    (correct, program out, solution)
    """
    
    #progOut.flush() #make sure the file is up to date
    #progOut.seek(0) #go back to the begining of the file
  
    try:
      sol = []
      with open(solutionFileName, 'r') as solFil: #open the solution file
        for (_1,_2,_3) in zip(range(self.lines2skip), progOut, solFil): #somehow placin zip as the first argument fixes a bug
          pass #skip the leading lines of input
          
        sol = [] #the solution
        for line in solFil: #make it so that white space does not matter
          sol += line.strip().split()
          
        out = [] # the programs output
        for line in progOut: #make it so that white space will not be an issue
          out += line.strip().split()
          
        if(out != sol):#output does not match solution
          print('Output:', out)
          print('Solution:', sol)
          return (False, out, sol)
         
      return (True, out, sol) #if everything is correct and all lines in the solution file are used the student got it right
    except UnicodeDecodeError:
      return (False, 'NonUnicode Character', sol)
  # end _checkSolution

#end class Tester


if __name__ =='__main__':
  #python = sys.executable
  t = Tester('./fpArithmetic.out', Tester.INPUT_CMDLINE, Tester.OUTPUT_STDOUT, 
              'Tests', 'Solutions', '.')
  t.testAll()
  for res in t.getResults():
    print(res)

