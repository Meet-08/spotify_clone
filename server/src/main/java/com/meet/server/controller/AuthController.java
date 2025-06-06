package com.meet.server.controller;

import com.meet.server.dto.SigninRequest;
import com.meet.server.dto.SigninResponse;
import com.meet.server.dto.SignupRequest;
import com.meet.server.model.User;
import com.meet.server.service.AuthService;
import com.meet.server.wrapper.UserWrapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final UserWrapper userWrapper;

    @GetMapping
    public ResponseEntity<User> currentUserData(Principal principal) {
        System.out.println("This is called");
        return authService.getCurrentUser(principal.getName());
    }

    @PostMapping("/signup")
    public ResponseEntity<User> signupUser(
            @Valid @RequestBody SignupRequest user
    ) {
        return authService.signupUser(userWrapper.convertToUser(user));
    }

    @PostMapping("/signin")
    public ResponseEntity<SigninResponse> signinUser(
            @Valid @RequestBody SigninRequest user
    ) {
        return authService.signinUser(userWrapper.convertToUser(user));
    }
}
