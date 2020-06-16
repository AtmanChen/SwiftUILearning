// 

import SwiftUI

extension Font {
  static func avenirNext(size: Int) -> Font {
    Font.custom("Avenir Next", size: CGFloat(size))
  }
  static func avenirNextRegular(size: Int) -> Font {
    Font.custom("AvenirNext-Regular", size: CGFloat(size))
  }
}

struct ContentView: View {
  private func getScrollOffset(_ geometryProxy: GeometryProxy) -> CGFloat {
    let offset = geometryProxy.frame(in: .global).minY
    return offset
  }
  private func getOffsetForHeaderImage(_ geometryProxy: GeometryProxy) -> CGFloat {
    let offset = getScrollOffset(geometryProxy)
    let sizeOffScreen = imageHeight - collapsedImageHeight
    if offset < -sizeOffScreen {
      let imageOffset = abs(min(-sizeOffScreen, offset))
      return imageOffset - sizeOffScreen
    }
    if offset > 0 {
      return -offset
    }
    return 0
  }
  private func headerImageHeight(_ geometryProxy: GeometryProxy) -> CGFloat {
    let offset = getScrollOffset(geometryProxy)
    let imageHeight = geometryProxy.size.height
    if offset > 0 {
      return imageHeight + offset
    }
    return imageHeight
  }
  private func blurRadiusForHeaderImage(_ geometryProxy: GeometryProxy) -> CGFloat {
    let offset = getScrollOffset(geometryProxy)
    let height = geometryProxy.size.height
    let blur = (height - max(offset, 0)) / height
    return blur * 6
  }
  private let imageHeight: CGFloat = 300
  private let collapsedImageHeight: CGFloat = 75
  var body: some View {
    ScrollView {
      GeometryReader { geometryReader in
        Image("background")
          .resizable()
          .scaledToFill()
          .frame(width: geometryReader.size.width, height: self.headerImageHeight(geometryReader))
          .blur(radius: self.blurRadiusForHeaderImage(geometryReader))
          .clipped()
          .offset(x: 0, y: self.getOffsetForHeaderImage(geometryReader))
      }.frame(height: 300)
      
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Image("person")
            .resizable()
            .scaledToFill()
            .frame(width: 55, height: 55)
            .clipShape(Circle())
            .shadow(radius: 4)
          
          VStack(alignment: .leading) {
            Text("Article Written By")
              .font(.avenirNext(size: 12))
              .foregroundColor(.gray)
            Text("Anderson Huang")
              .font(.avenirNext(size: 17))
          }
        }
        
        Text("02 January 2019 • 5 min read")
          .font(.avenirNextRegular(size: 12))
          .foregroundColor(.gray)
        
        Text("How to build a parallax scroll view")
          .font(.avenirNext(size: 28))
       
        Text(loremIpsum)
          .lineLimit(nil)
          .font(.avenirNextRegular(size: 17))
      }
      .padding(.horizontal)
      .padding(.top, 16)
    }
    .edgesIgnoringSafeArea([.top])
  }
}

let loremIpsum = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
"""
