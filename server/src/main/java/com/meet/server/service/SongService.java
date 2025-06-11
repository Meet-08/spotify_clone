package com.meet.server.service;

import com.meet.server.model.Song;
import com.meet.server.repository.SongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SongService {

    private final SongRepository songRepository;
    private final CloudinaryService cloudinaryService;

    public ResponseEntity<Song> uploadSong(Song song, MultipartFile thumbnail, MultipartFile songFile)
            throws IOException {
        Map<?, ?> thumbnailUploadResult = cloudinaryService.uploadImage(thumbnail);
        Map<?, ?> songUploadResult = cloudinaryService.uploadAudio(songFile);

        song.setSongUrl(songUploadResult.get("url").toString());
        song.setThumbnailUrl(thumbnailUploadResult.get("url").toString());

        Song savedSong = songRepository.save(song);
        clearSongCache();
        return ResponseEntity.status(HttpStatus.CREATED).body(savedSong);
    }

    @Cacheable(value = "songs", keyGenerator = "customKeyGenerator")
    public List<Song> getAllSongs() {
        return songRepository.findAll();
    }

    @CacheEvict(value = "songs", allEntries = true)
    public void clearSongCache() {
        System.out.println("Clearing song cache...");
    }
}
