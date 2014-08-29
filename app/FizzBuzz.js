(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.FizzBuzz = (function() {
    function FizzBuzz() {}

    FizzBuzz.prototype.returnString = function(n) {
      return "Fizz";
    };

    return FizzBuzz;

  })();

}).call(this);
