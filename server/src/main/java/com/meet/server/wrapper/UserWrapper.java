package com.meet.server.wrapper;

import com.meet.server.dto.SigninRequest;
import com.meet.server.dto.SignupRequest;
import com.meet.server.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserWrapper {

    private final PasswordEncoder encoder;

    public User convertToUser(SignupRequest request) {
        return User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(encoder.encode(request.getPassword()))
                .build();
    }

    public User convertToUser(SigninRequest request) {
        return User.builder()
                .email(request.getEmail())
                .password(request.getPassword())
                .build();
    }
}
