package com.meet.server.controller;

import com.meet.server.dto.SigninRequest;
import com.meet.server.dto.SignupRequest;
import com.meet.server.model.User;
import com.meet.server.service.AuthService;
import com.meet.server.wrapper.UserWrapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final UserWrapper userWrapper;

    @PostMapping("/signup")
    public ResponseEntity<User> signupUser(
            @Valid @RequestBody SignupRequest user
    ) {
        return authService.signupUser(userWrapper.convertToUser(user));
    }

    @PostMapping("/signin")
    public ResponseEntity<User> signinUser(
            @Valid @RequestBody SigninRequest user
    ) {
        return authService.signinUser(userWrapper.convertToUser(user));
    }
}
