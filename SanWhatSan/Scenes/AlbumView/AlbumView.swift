//
//  AlbumView.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/17/25.
//

import SwiftUI
import Photos

struct AlbumView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
//    @Environment(\.dismiss) var dismiss

    @State private var images: [UIImage] = []
    @State private var selectedImages: Set<UIImage> = []

    @State private var isSelectionMode = false
    @State private var showDeleteAlert = false

    @State private var isShareSheetPresented = false
    @State private var showPhotoDetail = false
    @State private var selectedImage: UIImage? = nil

    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        // MARK: - 더미 데이터
                        if images.isEmpty {
                            ForEach([UIImage(named: "FakePhoto")!], id: \.self) { image in
                                photoCell(image)
                            }
                        } else {
                            ForEach(images, id: \.self) { image in
                                photoCell(image)
                            }
                        }

                        // MARK: - 실제 촬영한 사진으로 돌아가게 할 코드
//                        ForEach(images, id: \.self) { image in
//                            ZStack(alignment: .topTrailing) {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .aspectRatio(9/16, contentMode: .fit)
//                                    .overlay(
//                                        isSelectionMode && selectedImages.contains(image)
//                                        ? Color.black.opacity(0.35)
//                                        : Color.clear
//                                    )
//                                    .onTapGesture {
//                                        if isSelectionMode {
//                                            toggleSelection(for: image)
//                                        } else {
//                                            selectedImage = image
//                                            showPhotoDetail = true
//                                        }
//                                    }
//
//                                if isSelectionMode {
//                                    Image(systemName: selectedImages.contains(image) ? "checkmark.circle.fill" : "circle")
//                                        .resizable()
//                                        .frame(width: 24, height: 24)
//                                        .foregroundColor(.blue)
//                                        .padding(6)
//                                }
//                            }
//                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 10)
                }

                if isSelectionMode {
                    Divider()
                    HStack {
                        Button(action: {
                            for img in selectedImages {
                                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                            }
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
                        coordinator.pop()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.neutrals5)
                            .clipShape(Circle())
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isSelectionMode {
                            selectedImages.removeAll()
                        }
                        isSelectionMode.toggle()
                    } label: {
                        Text(isSelectionMode ? "취소" : "선택")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(width: 63, height: 35)
                            .background(Color.neutrals5)
                            .clipShape(Capsule())
                    }
                    .padding(.trailing, 10)
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("사진 삭제"),
                    message: Text("선택한 사진을 삭제하겠산?"),
                    primaryButton: .destructive(Text("삭제")) {
                        images.removeAll { selectedImages.contains($0) }
                        selectedImages.removeAll()
                        isSelectionMode = false
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(activityItems: Array(selectedImages))
            }
//            .sheet(isPresented: $showPhotoDetail) {
//                if let selectedImage {
//                    PhotoDetailView(
//                        image: selectedImage,
//                        onDelete: {
//                            images.removeAll { $0 == selectedImage }
//                        }
//                    )
//                    coordinator.push(.photoDetailView(DisplayImage(id: UUID(), image: selectedImage)))
//                }
//            }
            .onAppear {
                fetchRecentPhotos()
            }
        }
    }

    // MARK: - 추출한 셀 뷰
    @ViewBuilder
    private func photoCell(_ image: UIImage) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(9/16, contentMode: .fit)
                .overlay(
                    isSelectionMode && selectedImages.contains(image)
                    ? Color.black.opacity(0.35)
                    : Color.clear
                )
                .onTapGesture {
                    if isSelectionMode {
                        toggleSelection(for: image)
                    } else {
                        coordinator.push(.photoDetailView(DisplayImage(id: UUID(), image: image)))
                    }
                }
        }
    }

    private func toggleSelection(for image: UIImage) {
        if selectedImages.contains(image) {
            selectedImages.remove(image)
        } else {
            selectedImages.insert(image)
        }
    }

    private func fetchRecentPhotos() {
        var loadedImages: [UIImage] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 50

        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let manager = PHImageManager.default()
        let imageSize = CGSize(width: 300, height: 300)

        assets.enumerateObjects { asset, _, _ in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    loadedImages.append(image)
                }
            }
        }

        self.images = loadedImages
    }
}

#Preview {
    AlbumView()
}
