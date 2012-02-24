(function() {
  var PatternMatching, isArray, isEqual, pattern, root, _,
    __slice = Array.prototype.slice;

  _ = require('underscore');

  isArray = _.isArray;

  isEqual = _.isEqual;

  PatternMatching = (function() {

    function PatternMatching(_f) {
      this._f = _f;
    }

    return PatternMatching;

  })();

  PatternMatching.prototype.when = function(predicates, exp) {
    var _this = this;
    return new PatternMatching(function(inner) {
      var fail, i, match, ps, _ref;
      match = _this._f(inner);
      if (match.success) {
        return match;
      } else {
        fail = function() {
          return {
            value: match.value,
            success: false
          };
        };
        ps = isArray(predicates) ? predicates : [predicates];
        if (ps.length === match.value.length) {
          for (i = 0, _ref = ps.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
            if (ps[i].apply(_this, [match.value[i]]) !== true) return fail();
          }
          return {
            value: exp.apply(_this, match.value),
            success: true
          };
        } else {
          return fail();
        }
      }
    });
  };

  PatternMatching.prototype.any = function(valExp) {
    var _this = this;
    return new PatternMatching(function(inner) {
      var match;
      match = _this._f(inner);
      if (match.success) {
        return match;
      } else {
        return {
          value: valExp(),
          success: true
        };
      }
    });
  };

  PatternMatching.prototype.matching = PatternMatching.prototype.end = function() {
    var _this = this;
    return function() {
      var inner, ret;
      inner = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      ret = _this._f(inner);
      if (ret.success) {
        return ret.value;
      } else {
        return;
      }
    };
  };

  PatternMatching.prototype.value = function(expected, valExp) {
    var e, predicates, _i, _len;
    predicates = [];
    if (isArray(expected)) {
      for (_i = 0, _len = expected.length; _i < _len; _i++) {
        e = expected[_i];
        predicates.push(function(val) {
          return isEqual(val, e);
        });
      }
    } else {
      predicates.push(function(val) {
        return isEqual(val, expected);
      });
    }
    return this.when(predicates, function(val) {
      return valExp(val);
    });
  };

  PatternMatching.prototype.direct = function(directExp) {
    var _this = this;
    return new PatternMatching(function(inner) {
      var match;
      match = _this._f(inner);
      if (match.success) {
        return match;
      } else {
        if (match.value.length === directExp.length) {
          return {
            value: directExp.apply(_this, match.value),
            success: true
          };
        } else {
          return {
            value: match.value,
            success: false
          };
        }
      }
    });
  };

  PatternMatching.prototype.some = function(patterns, exp) {
    var getPredicate, p, predicates;
    getPredicate = function(pattern) {
      if (typeof pattern === 'undefined') {
        return function(val) {
          return true;
        };
      } else if (typeof pattern === 'function') {
        return pattern;
      } else if (isArray(pattern)) {
        return function(val) {
          var p;
          p = function() {
            var v, _i, _len;
            for (_i = 0, _len = val.length; _i < _len; _i++) {
              v = val[_i];
              if (!getPredicate(v)) return false;
            }
            return true;
          };
          return isArray(val) && val.length === pattern.length && p();
        };
      } else if ((typeof pattern === 'object') && (typeof pattern._wrapped___func === 'function')) {
        return function(val) {
          return isEqual(val, pattern._wrapped___func);
        };
      } else {
        return function(val) {
          return isEqual(val, pattern);
        };
      }
    };
    predicates = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = patterns.length; _i < _len; _i++) {
        p = patterns[_i];
        _results.push(getPredicate(p));
      }
      return _results;
    })();
    return this.when(predicates, function(val) {
      return exp(val);
    });
  };

  pattern = function() {
    return new PatternMatching(function(inner) {
      return {
        value: inner,
        success: false
      };
    });
  };

  pattern.constfunc = function(func) {
    return {
      _wrapped___func: func
    };
  };

  root = this;

  if (typeof exports !== 'undefined') exports.pattern = pattern;

  if (typeof module !== 'undefined') module.exports = pattern;

  root.pattern = pattern;

}).call(this);
