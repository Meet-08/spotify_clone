package com.meet.server.controller;

import com.meet.server.model.FavoriteSong;
import com.meet.server.model.Song;
import com.meet.server.service.SongService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/song")
@RequiredArgsConstructor
public class SongController {

    private final SongService songService;

    @PostMapping(value = "/upload", consumes = "multipart/form-data")
    public ResponseEntity<Song> upload(
            @Valid @RequestPart String songName,
            @Valid @RequestPart String artist,
            @Valid @RequestPart String hexCode,
            @Valid @RequestPart MultipartFile thumbnail,
            @Valid @RequestPart MultipartFile songFile
    ) throws IOException {
        Song song = Song.builder()
                .songName(songName)
                .artist(artist)
                .hexCode(hexCode)
                .build();
        return songService.uploadSong(song, thumbnail, songFile);
    }

    @GetMapping("/list")
    public ResponseEntity<List<Song>> listSong() {
        return ResponseEntity.ok(songService.getAllSongs());
    }

    @PostMapping("/favorite")
    public ResponseEntity<Map<String, Boolean>> favoriteSong(
            @Valid @RequestBody FavoriteSong favoriteSong,
            Principal principal
    ) {
        return ResponseEntity.ok(songService.favoriteSong(favoriteSong, principal.getName()));
    }

    @GetMapping("/list/favorite")
    public ResponseEntity<List<FavoriteSong>> getAllFavoriteSongs(Principal principal) {
        UUID userId = UUID.fromString(principal.getName());
        return ResponseEntity.ok(songService.getAllFavoriteSongs(userId));
    }

}
