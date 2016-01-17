
```elm
import Storage.Local as Storage
import Json.Decode as Json

encoder : MyType -> Json.Value
decoder : Json.Decoder MyType

myStorage = Storage.object "myStorage" encoder decoder

myStorage.get () -- Read value
myStorage.put myValue -- Write value
```
