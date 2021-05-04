package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.User
import org.springframework.web.multipart.MultipartFile

/**
 * Интерфейс для описания операций для взаимодействия с изображениями пользователей.
 * @see com.goga133.hsecoffee.service.ImageStorageService
 */
interface ImageStorageRepository {
    /**
     * Метод для проверки корректности файла.
     */
    fun correctFile(file: MultipartFile): Boolean

    /**
     * Метод для сохранения файла для юзера.
     */
    fun store(file: MultipartFile, user: User)
}