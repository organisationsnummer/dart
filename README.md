# organisationsnummer [![Build Status](https://github.com/organisationsnummer/dart/workflows/test/badge.svg)](https://github.com/organisationsnummer/dart/actions)

Validate Swedish organization numbers. Follows version 1.1 of the [specification](https://github.com/organisationsnummer/meta#package-specification-v11).

## Example

```dart
import 'package:organisationsnummer/organisationsnummer.dart';

Organisationsnummer.valid('202100-5489');
//=> true
```

See [test/organisationsnummer.dart](test/organisationsnummer.dart) for more examples.

## In memoriam

Fredrik "Frozzare" Forsmo (1991-2026) was the initiator, co-founder and a core contributor of the organisationsnummer project. This library carries his work. He is missed.

## License

MIT