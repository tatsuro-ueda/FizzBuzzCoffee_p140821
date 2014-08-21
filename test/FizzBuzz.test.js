(function() {
  var expect, fizzbuzz;

  expect = require('expect.js');

  fizzbuzz = require('../app/FizzBuzz.js');

  describe('fizzbuzz', function() {
    var f;
    f = new fizzbuzz.FizzBuzz;
    return it('return string Fizz when 3 is given', function() {
      var result;
      result = f.returnString(3);
      return expect(result).to.be('Fizz');
    });
  });

}).call(this);
