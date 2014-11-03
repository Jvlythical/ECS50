#!/usr/bin/local/python3
import sys 

def editDistance(str1, str2):
  """creates the edit distance matrix between str1 and str2
  the actual edit distance will be at distances[-1][-1]
  @str1: the first string
  @str2: the second string
  @returns: the edit distance between str1 and str2
  """
  distances = [] #create the distances matrixrix
  rowDim = len(str1) + 1
  colDim = len(str2) + 1
  for i in range(rowDim):
    distances.append([0] * colDim)

  #initialize the distances matrix
  #the first row shows how much it costs to convert str2[:i] to ''
  #the first column shols how much it costs to convert str1[:j] to ''
  distances[0] = list(range(colDim))
  for i in range(rowDim):
    distances[i][0] = i

  for i in range(1, rowDim):
    for j in range(1, colDim):
      if(str1[i-1] == str2[j-1]): #characters at this position are the same
        distances[i][j] = distances[i-1][j-1] #so no cost to change
      else:
        distances[i][j] = min(distances[i-1][j], #deletion
                      distances[i][j-1], #insertion
                      distances[i-1][j-1]) + 1 #substitution
  
  return distances[-1][-1]
#end edit distance

def editDistanceOpt(str1, str2):
  """finds the edit distance between str1 and str2
  but is more space efficient.
  @str1: the first string
  @str2: the second string
  @returns: the edit distance between str1 and str2
  """
  oldDist = list(range(len(str2) + 1))
  curDist = oldDist.copy()

  for i in range(1, len(str1) + 1): #for each character in the first string
    curDist[0] = i
    for j in range(1, len(str2) + 1): #for each character in the second string
      if(str1[i-1] == str2[j-1]): #characters at this position are the same
        curDist[j] = oldDist[j-1]
      else:
        curDist[j] = min(oldDist[j], #deletion
                      curDist[j-1], #insertion
                      oldDist[j-1]) + 1 #substitution
    #end inner for
    oldDist = curDist.copy()
  #end outer for
    
  return curDist[-1]
#end editDistanceOpt

if __name__ == '__main__':
  print(editDistanceOpt(sys.argv[1], sys.argv[2]))
  
