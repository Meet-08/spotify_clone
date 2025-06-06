package com.meet.server.dto;

import com.meet.server.model.User;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SigninResponse {

    private User user;
    private String token;
}
