package com.meet.server.service;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CloudinaryService {

    private final Cloudinary cloudinary;

    public Map uploadImage(MultipartFile file) throws IOException {

        File convertedFile = convertMultipartFileToFile(file);
        String folder = "spotify_clone/thumbnails";
        Map uploadResult = cloudinary.uploader().upload(convertedFile, ObjectUtils.asMap(
                "folder", folder
        ));
        // Clean up the temporary file after upload
        convertedFile.delete();
        return uploadResult;
    }

    public Map uploadAudio(MultipartFile file) throws IOException {

        File convertedFile = convertMultipartFileToFile(file);
        String folder = "spotify_clone/songs";
        Map uploadResult = cloudinary.uploader().upload(convertedFile, ObjectUtils.asMap(
                "resource_type", "auto",
                "folder", folder
        ));
        // Clean up the temporary file after upload
        convertedFile.delete();
        return uploadResult;
    }

    public Map deleteImage(String publicId) throws IOException {
        return cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
    }

    private File convertMultipartFileToFile(MultipartFile file) throws IOException {
        File convFile = new File(System.getProperty("java.io.tmpdir") + "/" + file.getOriginalFilename());
        file.transferTo(convFile);
        return convFile;
    }

}
