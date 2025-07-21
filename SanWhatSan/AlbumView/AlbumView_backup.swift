//
//  AlbumView_backup.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/20/25.
//

import SwiftUI

struct AlbumView_backup: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var images: [String] = (1...12).map { "photo\($0)" }.reversed()
    @State private var selectedImages: Set<String> = []
    
    @State private var isSelectionMode: Bool = false
    @State private var showDeleteAlert: Bool = false
    
// MARK: - 공유 상태
    @State private var isShareSheetPresented: Bool = false
    @State private var shareItems: [Any] = []

// MARK: - 사진 뜨는 곳
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(images, id: \.self) { name in
                            ZStack(alignment: .topTrailing) {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.3))
                                    .aspectRatio(9/16, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "photo")

                                    )
                                    .overlay(
                                        isSelectionMode && selectedImages.contains(name)
                                        ? Color.black.opacity(0.35)
                                        : Color.clear
                                    )
                                    .onTapGesture {
                                        if isSelectionMode {
                                            if selectedImages.contains(name) {
                                                selectedImages.remove(name)
                                            } else {
                                                selectedImages.insert(name)
                                            }
                                        }
                                    }
                                
                                if isSelectionMode {
                                    Image(systemName: selectedImages.contains(name) ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                        .padding(6)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 10)
                }
                
                if isSelectionMode {
                    Divider()
                    HStack {
                        Button(action: {
                            print("저장: \(selectedImages)")
                        }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        Text("\(selectedImages.count)장 선택됨")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            shareItems = selectedImages.map { "\($0).jpg" } // or UIImage array
                            isShareSheetPresented = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemGray6))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color("Neutrals5"))
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isSelectionMode {
                            selectedImages.removeAll()
                            isSelectionMode = false
                        } else {
                            isSelectionMode = true
                        }
                    } label: {
                        Text(isSelectionMode ? "취소" : "선택")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 63, height: 35)
                            .background(Color("Neutrals5"))
                            .clipShape(Capsule())
                    }
                    .padding(.trailing, 10)
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("사진 삭제"),
                    message: Text("선택한 사진을 삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        images.removeAll { selectedImages.contains($0) }
                        selectedImages.removeAll()
                        isSelectionMode = false
                    },
                    secondaryButton: .cancel()
                )
            }
// MARK: - ShareSheet 사용
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: shareItems)
            }
        }
    }
}








#Preview {
    AlbumView_backup()
}
