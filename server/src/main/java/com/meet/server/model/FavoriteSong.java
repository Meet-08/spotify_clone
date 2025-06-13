package com.meet.server.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class FavoriteSong {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @ManyToOne
    private Song song;

    @ManyToOne
    private User user;

}
