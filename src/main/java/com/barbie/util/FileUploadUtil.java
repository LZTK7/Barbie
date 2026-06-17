package com.barbie.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUploadUtil {

    private static final String UPLOAD_DIR = "uploads";

    /**
     * 保存上传的文件
     * @param part 文件部分
     * @param realPath 项目真实路径（request.getServletContext().getRealPath("/")）
     * @return 保存后的文件路径（相对路径）
     */
    public static String saveFile(Part part, String realPath) throws IOException {
        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // 获取文件扩展名
        String ext = "";
        int lastDot = fileName.lastIndexOf(".");
        if (lastDot > 0) {
            ext = fileName.substring(lastDot);
        }

        // 生成唯一文件名
        String newFileName = UUID.randomUUID().toString() + ext;

        // 构建保存路径
        String savePath = realPath + File.separator + UPLOAD_DIR;
        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 保存文件
        part.write(savePath + File.separator + newFileName);

        return UPLOAD_DIR + "/" + newFileName;
    }
}