package com.meet.server.dto;

import lombok.Data;
import org.springframework.http.HttpStatusCode;


@Data
public class ErrorResponse {

    private String message;
    private HttpStatusCode status;

    public ErrorResponse(String message, HttpStatusCode code) {
        this.message = message;
        this.status = code;
    }
}
