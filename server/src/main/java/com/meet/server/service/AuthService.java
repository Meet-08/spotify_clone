package com.meet.server.service;

import com.meet.server.error.CustomException;
import com.meet.server.model.User;
import com.meet.server.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder encoder;

    public ResponseEntity<User> signupUser(User user) {
        var existingUser = userRepository.findByEmail(user.getEmail());

        if (existingUser.isPresent()) throw new CustomException("Email already exist", HttpStatus.BAD_REQUEST);

        User savedUser = userRepository.save(user);

        return ResponseEntity.status(HttpStatus.CREATED).body(savedUser);
    }

    public User signinUser(User user) {
        var existingUser = userRepository
                .findByEmail(user.getEmail())
                .orElseThrow(
                        () -> new CustomException("User not found", HttpStatus.BAD_REQUEST)
                );

        if (!encoder.matches(user.getPassword(), existingUser.getPassword()))
            throw new CustomException("Incorrect password", HttpStatus.FORBIDDEN);

        return existingUser;
    }
}
