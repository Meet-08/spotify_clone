package com.meet.server.service;

import com.meet.server.dto.SigninResponse;
import com.meet.server.error.CustomException;
import com.meet.server.model.User;
import com.meet.server.repository.UserRepository;
import com.meet.server.utils.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder encoder;
    private final JwtUtil jwtUtil;

    public ResponseEntity<User> signupUser(User user) {
        var existingUser = userRepository.findByEmail(user.getEmail());

        if (existingUser.isPresent())
            throw new CustomException("User with same email already exist", HttpStatus.BAD_REQUEST);

        User savedUser = userRepository.save(user);

        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
    }

    public ResponseEntity<SigninResponse> signinUser(User user) {
        var existingUser = userRepository
                .findByEmail(user.getEmail())
                .orElseThrow(
                        () -> new CustomException("User not found", HttpStatus.BAD_REQUEST)
                );

        if (!encoder.matches(user.getPassword(), existingUser.getPassword()))
            throw new CustomException("Incorrect password", HttpStatus.FORBIDDEN);

        String token = jwtUtil.createToken(existingUser.getId());

        var response = SigninResponse.builder()
                .user(existingUser)
                .token(token)
                .build();

        return ResponseEntity.ok(response);
    }

    public ResponseEntity<User> getCurrentUser(String id) {
        var user = userRepository.findById(UUID.fromString(id)).orElseThrow(
                () -> new CustomException("User not found", HttpStatus.BAD_REQUEST)
        );

        return ResponseEntity.ok(user);
    }
}
