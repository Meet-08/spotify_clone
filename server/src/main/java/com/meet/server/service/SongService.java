package com.meet.server.service;

import com.meet.server.model.FavoriteSong;
import com.meet.server.model.Song;
import com.meet.server.model.User;
import com.meet.server.repository.FavoriteSongRepository;
import com.meet.server.repository.SongRepository;
import com.meet.server.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SongService {

    private final UserRepository userRepository;
    private final SongRepository songRepository;
    private final FavoriteSongRepository favoriteSongRepository;
    private final CloudinaryService cloudinaryService;

    @CacheEvict(value = "songs", allEntries = true)
    public ResponseEntity<Song> uploadSong(Song song, MultipartFile thumbnail, MultipartFile songFile)
            throws IOException {
        Map<?, ?> thumbnailUploadResult = cloudinaryService.uploadImage(thumbnail);
        Map<?, ?> songUploadResult = cloudinaryService.uploadAudio(songFile);

        song.setSongUrl(songUploadResult.get("url").toString());
        song.setThumbnailUrl(thumbnailUploadResult.get("url").toString());

        Song savedSong = songRepository.save(song);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedSong);
    }

    @Cacheable(value = "songs", keyGenerator = "customKeyGenerator")
    public List<Song> getAllSongs() {
        return songRepository.findAll();
    }

    @Transactional
    @CacheEvict(value = "fav-songs", allEntries = true)
    public Map<String, Boolean> favoriteSong(
            FavoriteSong favoriteSong,
            String userId
    ) {
        var favSong = favoriteSongRepository.getFavoriteSongbyFilter(
                UUID.fromString(userId),
                favoriteSong.getSong().getId()
        );

        if (favSong.isPresent()) {
            favoriteSongRepository.delete(favSong.get());
            return Map.of("message", false);
        }

        User user = userRepository.getReferenceById(UUID.fromString(userId));
        Song song = songRepository.getReferenceById(favoriteSong.getSong().getId());

        favoriteSong.setUser(user);
        favoriteSong.setSong(song);

        favoriteSongRepository.save(favoriteSong);

        return Map.of("message", true);
    }

    @Cacheable(value = "fav-songs")
    public List<FavoriteSong> getAllFavoriteSongs(UUID userId) {
        return favoriteSongRepository.findAllByUser_Id(userId);
    }
}
