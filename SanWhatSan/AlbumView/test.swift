//
//  test.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/18/25.
//


import SwiftUI

struct testView: View {
// MARK: - 임시 이미지 데이터 (CameraView에서 촬영된 이미지 경로라고 가정)
    // 최신 이미지가 먼저 나오도록 역순 정렬
    let dummyImages = (1...12).map { "photo\($0)" }.reversed() // 최신 → 오래된 순서
    
    // dummyImages 말고 실제 사진 불러 봐야 할때 사용할 코드(아래에 있음)
    //let images: [UIImage] = loadImages().reversed()

// MARK: - 3열 Grid
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(dummyImages, id: \.self) { name in
                        Rectangle()
                            .fill(Color.blue.opacity(0.3)) // 파란색으로 더미 이미지
                            .aspectRatio(9/16, contentMode: .fit)
                            .overlay(
                                Image(systemName: "photo")
                            )
//dummyImages 말고 실제 사진 불러 와서 사용할 코드 (아래에 있음)
//                        ForEach(Array(images.enumerated()), id: \.offset) { index, image in
//                                                Image(uiImage: image)
//                                                    .resizable()
//                                                    .aspectRatio(9/16, contentMode: .fit)
//                                                    .clipped()
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
// MARK: - 왼쪽: 이전 화면으로 (CameraView로 돌아가기)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // MARK: CameraView로 돌아가기 (나중에 연결)
                        // navigateToCameraView()
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16) // 아이콘 크기
                            .foregroundColor(.black)
                            .padding(12) // 내부 여백
                            .background(Color("Neutrals5")) // 에셋에 있는 색상 사용
                            .clipShape(Circle()) // 원형으로 자르기
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }

// MARK: - 오른쪽: 선택 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 선택 기능 추가 예정
                    }) {
                        Text("선택")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 63, height: 35)
                            .background(Color("Neutrals5")) // 에셋에서 Neutrals5 색상 사용
                            .clipShape(Capsule()) // 라운드된 버튼
                    }
                    .padding(.trailing, 10)
                }
            }
        }
    }
}



#Preview {
    testView()
}
