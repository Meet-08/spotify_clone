package com.meet.server.controller;

import com.meet.server.model.Song;
import com.meet.server.service.SongService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

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
        System.out.println(hexCode);
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
}
