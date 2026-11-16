<?php
/**
 * Shared helper functions
 * Campus Room Allocation System
 */

/*
 * URL path the app is served from, e.g. "/" or "/csc433/".
 * Worked out from the document root; define BASE_URL in config/database.php to override.
 */
if (!defined('BASE_URL')) {
    $docRoot = isset($_SERVER['DOCUMENT_ROOT']) ? realpath($_SERVER['DOCUMENT_ROOT']) : false;
    $appRoot = realpath(__DIR__ . '/..');
    $path = ($docRoot && strpos($appRoot, $docRoot) === 0) ? substr($appRoot, strlen($docRoot)) : '';
    define('BASE_URL', rtrim(str_replace('\\', '/', $path), '/') . '/');
}

if (!function_exists('sanitize')) {
    /**
     * Trims a form value and strips HTML tags.
     * Queries use prepared statements, so this is only for tidying input.
     * Escape output with htmlspecialchars() when you print it.
     */
    function sanitize($value): string
    {
        return trim(strip_tags((string) $value));
    }
}

if (!function_exists('isValidEmail')) {
    /** Returns true when the string is a valid email address. */
    function isValidEmail(string $email): bool
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }
}
