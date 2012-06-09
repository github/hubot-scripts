# Description:
#   Calculate the nth fibonacci number. #webscale
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   fibonacci me <integer> - Calculate Nth Fibonacci number
#
# Author:
#   ckdake

fib_bits = (n) ->
  # Represent an integer as an array of binary digits.
  bits = []
  while n > 0
    [n, bit] = divmodBasic(n, 2)
    bits.push(bit)
  return bits.reverse()

fibFast = (n) ->
  [a, b, c] = [1, 0, 1]
  
  for bit in fib_bits(n)
    if bit
      [a, b] = [(a+c)*b, b*b + c*c]
    else
      [a, b] = [a*a + b*b, (a+c)*b]
    c = a + b
  return b

divmodBasic = (x, y) ->
  return [(q = Math.floor(x/y)), (r = if x < y then x else x % y)]

module.exports = (robot) ->
  robot.hear /fibonacci me (\d+)/i, (msg) ->
    msg.send fibFast(msg.match[1]).toString()
