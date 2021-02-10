import '../services/location.dart';
import '../services/networking.dart';


class WeatherModel {
  static String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }



  // String getMessage(int temp) {
  //   if (temp > 25) {
  //     return 'It\'s 🍦 time';
  //   } else if (temp > 20) {
  //     return 'Time for shorts and 👕';
  //   } else if (temp < 10) {
  //     return 'You\'ll need 🧣 and 🧤';
  //   } else {
  //     return 'Bring a 🧥 just in case';
  //   }
  // }
}
const apiKey = '4cc0b548d4ce485830092023fcfeea03';

class Weather {
  dynamic _weatherData;

  Weather(this._weatherData);

  dynamic getRawWeatherData() {
    return _weatherData;
  }

  dynamic getHourWeather(DateTime hour) {
    // get weather for a specific hour
    var hourInSeconds = hour.millisecondsSinceEpoch / 1000;

    for (var i = 0; i < _weatherData['hourly'].length; i++) {
      if (_weatherData['hourly'][i]['dt'] == hourInSeconds) {
        return _weatherData['hourly'][i];
      }
    }
  }

  static bool isGoodWeather(dynamic weatherInfo) {
    return weatherInfo['weather'][0]['id'] >= 600;
  }

  // get next "good" hour

  static Future<Weather> getWeather() async {
    Location location = Location();
    print("Getting location");
    await location.getCurrentLocation();
    double latitude = location.latitude;
    double longitude = location.longitude;

    print("Getting weather data for $latitude $longitude");
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&units=imperial');
    var weatherDataResponse = await networkHelper.getData();
    // var time = weatherDataResponse['hourly'][0]['dt'];

    return Weather(weatherDataResponse);
  }
}
