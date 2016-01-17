Elm.Native.Storage = {};
Elm.Native.Storage.Local = {};
Elm.Native.Storage.Local.make = function(elm) {
  elm.Native = elm.Native || {};
  elm.Native.Storage = elm.Native.Storage || {};
  elm.Native.Storage.Local = elm.Native.Storage.Local || {};
  if (elm.Native.Storage.Local.values) return elm.Native.Storage.Local.values;

  var available = !!window.localStorage;

  function get(key) {
    if (!available) {
      return { ctor: "Err", _0: "LocalStorage is not available" }
    }
    var json = window.localStorage.getItem(key);
    try {
      var value = JSON.parse(json);
    } catch (e) {
      return { ctor: "Err", _0: "Invalid JSON" }
    }
    console.log("Storage.Local.get", key, value);
    return { ctor: "Ok", _0: value }
  }

  function put(key, value) {
    if (!available) {
      return { ctor: "Err", _0: "LocalStorage is not available" }
    }
    var json = JSON.stringify(value);
    try {
      window.localStorage.setItem(key, json);
    } catch (e) {
      return { ctor: "Err", _0: "LocalStorage is full" }
    }
    console.log("Storage.Local.put", key, value);
    return { ctor: "Ok", _0: { ctor: "_Tuple0" }
    }
  }

  return elm.Native.Storage.Local.values = {
    get: get,
    put: F2(put),
    isAvailable : available
  };
};
