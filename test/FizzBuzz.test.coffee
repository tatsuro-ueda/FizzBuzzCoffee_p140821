expect = require 'expect.js'
fizzbuzz = require '../app/FizzBuzz.js'

describe 'fizzbuzz', ->

    f = new fizzbuzz.FizzBuzz

    it 'return string Fizz when 3 is given', ->
        result = f.returnString( 3 )
        expect( result ).to.be( 'Fizz' )
        