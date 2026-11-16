<?php
/**
 * Database configuration and helpers
 * Campus Room Allocation System
 *
 * Copy this file to config/database.php and fill in your own credentials.
 * config/database.php is git-ignored so your password never gets committed.
 */

require_once __DIR__ . '/../includes/functions.php';

define('DB_HOST', 'localhost');
define('DB_NAME', 'campus_room_allocation');
define('DB_USER', 'root');
define('DB_PASS', '');

/**
 * Returns a shared PDO connection.
 */
function getConnection(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4';
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]);
    }
    return $pdo;
}

/** Runs a prepared statement and returns it. */
function executeQuery(string $sql, array $params = []): PDOStatement
{
    $stmt = getConnection()->prepare($sql);
    $stmt->execute($params);
    return $stmt;
}

/** Returns the first row, or false when there are no rows. */
function fetchOne(string $sql, array $params = [])
{
    return executeQuery($sql, $params)->fetch();
}

/** Returns all rows as an array. */
function fetchAll(string $sql, array $params = []): array
{
    return executeQuery($sql, $params)->fetchAll();
}

function getLastInsertId(): string
{
    return getConnection()->lastInsertId();
}

function beginTransaction(): bool
{
    return getConnection()->beginTransaction();
}

function commit(): bool
{
    return getConnection()->commit();
}

function rollback(): bool
{
    $pdo = getConnection();
    return $pdo->inTransaction() ? $pdo->rollBack() : false;
}

/** Returns true when the database can be reached. */
function testConnection(): bool
{
    try {
        getConnection()->query('SELECT 1');
        return true;
    } catch (PDOException $e) {
        error_log('Database connection failed: ' . $e->getMessage());
        return false;
    }
}
