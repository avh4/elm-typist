var sinon = require('sinon');

// Stub Elm
var fs = require('fs');
var F2 = function(f) {
  return function(a) {
    return function(b) {
      return f(a, b);
    }
  }
};


describe('Native.Storage.Local', function() {
  describe('when localStorage is available', function() {
    beforeEach(function() {
      global.window = {
        localStorage: {}
      };

      global.Elm = {};
      Elm.Native = {};
      eval(fs.readFileSync('./src/Native/Storage/Local.js') + '');
      Elm.Native.Storage.Local.make(Elm);
    });

    it('should indicate availability', function() {
      var result = Elm.Native.Storage.Local.values.isAvailable;
      expect(result).toEqual(true);
    });

    describe('get', function() {
      it('should read from localStorage', function() {
        window.localStorage.getItem = sinon.stub().withArgs("key1").returns("{\"a\":7}");

        var result = Elm.Native.Storage.Local.values.get("key1");

        expect(result.ctor).toBe("Ok");
        expect(result._0).toEqual({
          a: 7
        });
      });

      it('should return null when values does not exist', function() {
        window.localStorage.getItem = sinon.stub().withArgs("key1").returns(null);

        var result = Elm.Native.Storage.Local.values.get("key1");

        expect(result.ctor).toBe("Ok");
        expect(result._0).toBeNull();
      });

      it('should give an error when JSON does not parse', function() {
        window.localStorage.getItem = sinon.stub().withArgs("key1").returns("{{{BAD JSON");

        var result = Elm.Native.Storage.Local.values.get("key1");

        expect(result.ctor).toBe("Err");
        expect(result._0).toEqual("Invalid JSON");
      });
    });

    describe('put', function() {
      it('should write to localStorage', function() {
        window.localStorage.setItem = sinon.spy();

        var result = Elm.Native.Storage.Local.values.put("key1")({a:8});

        expect(result.ctor).toBe("Ok");
        expect(result._0.ctor).toEqual("_Tuple0");
      });

      it('should give an error when localStorage is full', function() {
        window.localStorage.setItem = sinon.stub().throws();

        var result = Elm.Native.Storage.Local.values.put("key1")({a:8});

        expect(result.ctor).toBe("Err");
        expect(result._0).toEqual("LocalStorage is full");
      });
    });
  });

  describe("when localStorage is not available", function() {
    beforeEach(function() {
      global.window = {};

      global.Elm = {};
      Elm.Native = {};
      eval(fs.readFileSync('./src/Native/Storage/Local.js') + '');
      Elm.Native.Storage.Local.make(Elm);
    });

    it('should indicate availability', function() {
      var result = Elm.Native.Storage.Local.values.isAvailable;
      expect(result).toEqual(false);
    });

    it('get: should return an error', function() {
      var result = Elm.Native.Storage.Local.values.get("key1");

      expect(result.ctor).toBe("Err");
      expect(result._0).toEqual("LocalStorage is not available");
    });

    it('put: should return an error', function() {
      var result = Elm.Native.Storage.Local.values.put("key1")({});

      expect(result.ctor).toBe("Err");
      expect(result._0).toEqual("LocalStorage is not available");
    });
  });
});
