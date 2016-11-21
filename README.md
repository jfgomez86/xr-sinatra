### README

XR-Sinatra is a simple currency exchange rate (Base USD *only* for now) API designed to display
the current exchange rate selected as an image.

## Usage

There are two endpoints currently:

*Get currency exchange with USD base*: Simply visit `/:Currency` to receive a PNG image with the data. Example:

```
GET /COP - 200 OK # returns a image with the value.
```

*Get currency exchange with other base*: You can change the base
currency used to perform the conversion using `/:base/to/:currency`.
Example:

```
GET /EUR/to/COP - 200 OK # returns a image with the value.
```

Returns the exchange rate for 1 EUR to COP.
