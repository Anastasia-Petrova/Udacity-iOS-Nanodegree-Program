import UIKit

func fizzBuzz(number: Int) {
    
    for num in 1...number {
        print(toFizzBuzz(number: num))
    }
}

func toFizzBuzz(number: Int) -> String {
    if number % 3 == 0 && number % 5 == 0 {
        return "FizzBuzz"
    } else if number % 3 == 0 {
        return "Fizz"
    } else if number % 5 == 0  {
        return "Buzz"
    } else {
        return "number"
    }
}

fizzBuzz(number: 5)
