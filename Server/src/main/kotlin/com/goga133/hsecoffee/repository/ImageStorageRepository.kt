package com.goga133.hsecoffee.repository

import com.goga133.hsecoffee.entity.User
import org.springframework.core.io.Resource
import org.springframework.web.multipart.MultipartFile
import java.nio.file.Path
import java.util.stream.Stream

interface ImageStorageRepository {
    fun correctFile(file: MultipartFile) : Boolean
    fun store(file: MultipartFile, user : User)
    fun loadFile(filename: String): Resource
    fun deleteAll()
    fun init()
    fun loadFiles(): Stream<Path>
}