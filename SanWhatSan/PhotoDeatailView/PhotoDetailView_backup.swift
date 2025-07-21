//
//  PhotoDetailView_backup.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/20/25.
//

import SwiftUI

struct PhotoDetailView_backup: View {
    @Environment(\.dismiss) var dismiss

    let image: UIImage
    let onDelete: () -> Void

    @State private var isShareSheetPresented = false
    @State private var showDeleteAlert = false
    

    var body: some View {
        VStack(spacing: 0) {
// MARK: - 상단 바 (뒤로 가기)
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.neutrals5)
                        .clipShape(Circle())
                }
                Spacer()
// 가운데 날짜 제외함, 코드에서 계속 오류나서 제외하고 함
                Spacer().frame(width: 40) // 균형 맞추기용
            }
            .padding(.horizontal)
            .padding(.top, 16)

            // MARK: - 이미지 영역
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: 0)
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(width: geometry.size.width * 0.85)
                        .frame(maxWidth: geometry.size.width)
                        .clipped()
                    Spacer(minLength: 0)
                }
            }

// MARK: - 프레임 버튼
            HStack {
                // Frame 꾸미기
                Button(action: {
                    // 프레임 꾸미기 기능 연결
                }) {
                    Image(systemName: "person.crop.artframe")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

                Spacer()

//MARK: - 저장
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

//MARK: -  공유
                Button(action: {
                    isShareSheetPresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

//MARK: -  삭제
                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

                // 아래에 붙이기 (View의 .alert)
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("사진 삭제"),
                        message: Text("정말로 이 사진을 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            onDelete()
                            dismiss()
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }

            }
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [image])
        }
    }
}

// MARK: - 대체 이미지 없이도 프리뷰에서 보게 만드려고 한것

//extension UIImage {
//    static func solidColor(_ color: UIColor = .gray, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { context in
//            color.setFill()
//            context.fill(CGRect(origin: .zero, size: size))
//        }
//    }
//}

#Preview {
    PhotoDetailView_backup(
        image: UIImage.solidColor(),
        onDelete: {}
    )
}
