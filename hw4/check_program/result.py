class Result(object):
  """
  a wrapper to contain the results of a test
  @testName: the name of the test run
  @correct:  True if the output of matched the solution; False otherwise
  @timeTaken is either
    the number of seconds it took the program to run
    'Timed Out' if the program took too long to complete
    'Crashed' if the program encountered some fatal error
  """
  def __init__(self, testName, correct, timeTaken):
    """
    @testName: the name of the test run
    @correct:  True if the output of matched the solution; False otherwise
    @timeTaken is either
      the number of seconds it took the program to run
      'Timed Out' if the program took too long to complete
      'Crashed' if the program encountered some fatal error
    """
    self.testName = testName
    self.correct = correct
    self.timeTaken = timeTaken
  #end init

  def __repr__(self):
    if type(self.timeTaken) == str:
      format_str = 'Test: {!s} | Correct: {!s} | Time Taken: {!s}'
    else:
      format_str = 'Test: {!s} | Correct: {!s} | Time Taken: {:.3f}'
  
    s = format_str.format(self.testName, self.correct, self.timeTaken)
    return s

  def __str__(self):
    return self.__repr__()
