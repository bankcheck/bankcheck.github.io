package com.systematic;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

@ControllerAdvice
public class FrancoGlobalExceptionHandler {

    @ExceptionHandler(NoHandlerFoundException.class) // Handles 404 errors
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ModelAndView handleNotFound(NoHandlerFoundException ex) {
        return new ModelAndView("errors/404"); // Redirect to 404 page
    }

    @ExceptionHandler(RuntimeException.class) // Handles runtime exceptions
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleRuntimeExceptions(RuntimeException ex) {
        return new ModelAndView("errors/500"); // Redirect to 500 page
    }

    @ExceptionHandler(Exception.class) // Handles all other exceptions
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ModelAndView handleAllExceptions(Exception ex) {
        return new ModelAndView("errors/500"); // Redirect to 500 page
    }
}