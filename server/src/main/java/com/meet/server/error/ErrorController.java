package com.meet.server.error;

import com.meet.server.dto.ErrorResponse;
import io.swagger.v3.oas.annotations.Hidden;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@Hidden
@RestControllerAdvice
public class ErrorController {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ErrorResponse> customError(CustomException e) {
        System.out.println(e.getMessage());
        ErrorResponse res = new ErrorResponse(e.getMessage(), e.getStatusCode());
        return ResponseEntity.status(res.getStatus()).body(res);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> methodArgumentNotValid(MethodArgumentNotValidException e) {
        Map<String, String> errors = new HashMap<>();
        for (int i = 0; i < e.getBindingResult().getFieldErrors().size(); i++) {
            String field = e.getBindingResult().getFieldErrors().get(i).getField();
            String errorMessage = e.getBindingResult().getFieldErrors().get(i).getDefaultMessage();
            errors.put(field, errorMessage);
        }
        return ResponseEntity.badRequest().body(errors);
    }
}
