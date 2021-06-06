/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct PrecipitationChart: View {
  var measurements: [DayInfo]
  
  func sumPrecipitation(_ month: Int) -> Double {
    self.measurements
      .filter {
        Calendar.current.component(.month, from: $0.date) == month + 1
    }
    .reduce(0) { $0 + $1.precipitation }
  }
  
  func monthAbbreviationFromInt(_ month: Int) -> String {
    let ma = Calendar.current.shortMonthSymbols
    return ma[month]
  }
  
  var body: some View {
    // 1
    HStack {
      // 2
      ForEach(0..<12) { month in
        // 3
        VStack {
          // 4
          Spacer()
          Text("\(self.sumPrecipitation(month).stringToOneDecimal)")
            .font(.footnote)
            .rotationEffect(.degrees(-90))
            .offset(y: self.sumPrecipitation(month) < 2.4 ? 0 : 35)
            .zIndex(1)
          // 5
          Rectangle()
            .fill(Color.green)
            .frame(width: 20, height: CGFloat(self.sumPrecipitation(month)) * 15.0)
          
          // 6
          Text("\(self.monthAbbreviationFromInt(month))")
            .font(.footnote)
            .frame(height: 20)
        }
      }
    }
  }
}

struct PrecipitationChart_Previews: PreviewProvider {
  static var previews: some View {
    PrecipitationChart(measurements: WeatherInformation()!.stations[2].measurements)
  }
}
