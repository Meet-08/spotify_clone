package com.meet.server.repository;

import com.meet.server.model.FavoriteSong;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface FavoriteSongRepository extends JpaRepository<FavoriteSong, Long> {

    @Query(
            "SELECT f FROM FavoriteSong  f WHERE f.user.id = :userId AND f.song.id = :song"
    )
    Optional<FavoriteSong> getFavoriteSongbyFilter(UUID userId, Long song);

    List<FavoriteSong> findAllByUser_Id(UUID userId);
}
