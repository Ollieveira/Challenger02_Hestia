//
//  AddNewRecipeView.swift
//  Challenger02_Hestia
//
//  Created by Guilherme Avila on 02/06/24.
//

import SwiftUI

struct AddNewRecipeView: View {
    
    @State var viewModel = MealViewModel.instance

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack{
                    HStack (spacing:0){
                        Text("Add more")
                        Text(" recipes")
                            .foregroundStyle(Color.tabViewCor)
                        Text("!")
                    }
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    HStack{
                        Text("Select one of the options bellow")
                    }
                    .font(.title2)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
                .padding(.top, 16)
                
                HStack {
                    NavigationLink(destination: WebScrapingView()) {
                        RoundedButtonView(imageName: "link.circle.fill", title: "Link", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5)
                    }
                    Spacer()

                    NavigationLink(destination: OCRView()) {
                        RoundedButtonView(imageName: "camera.fill", title: "Photo", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5)
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 16)

                HStack {
                    NavigationLink(destination: AddRecipeManually(viewModel: viewModel)) {
                        RoundedButtonView(imageName: "plus.circle.fill", title: "Create", backgroundColor: Color.bgFavCardCor, iconColor: Color.tabViewCor, width: geometry.size.width / 2.5)
                    }
                    
                    Spacer()

                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.horizontal, 16)


            }
            .padding(.horizontal, 8)
        }
        .background(Color.backgroundCor)
    }
}

struct RoundedButtonView: View {
    let imageName: String
    let title: String
    let backgroundColor: Color
    let iconColor: Color
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
                    .frame(width: width, height: width)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width / 3, height: width / 3)
                    .foregroundColor(iconColor)
            }
            Text(title)
                .fontDesign(.rounded)
                .font(.body)
        }
    }
}

struct AddNewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRecipeView()
    }
}
