package com.spark;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class DownloadServlet
 */
public class DownloadServlet extends HttpServlet {
    private boolean isMultipart;
    private String filePath;
    private int maxFileSize = 50 * 1024;
    private int maxMemSize = 4 * 1024;
    private File file;

    @Override
    public void init() {
	// 获取文件将被存储的位置
	filePath = getServletContext().getInitParameter("file-upload");
	;
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
	    throws ServletException, java.io.IOException {
	// 检查我们有一个文件上传请求
	isMultipart = ServletFileUpload.isMultipartContent(request);
	request.setCharacterEncoding("UTF-8");
	HttpSession session = request.getSession();
	if (!isMultipart) {
	    return;
	}
	DiskFileItemFactory factory = new DiskFileItemFactory();
	// 文件大小的最大值将被存储在内存中
	factory.setSizeThreshold(maxMemSize);
	// Location to save data that is larger than maxMemSize.
	factory.setRepository(new File("c:\\tmp"));

	// 创建一个新的文件上传处理程序
	ServletFileUpload upload = new ServletFileUpload(factory);
	// 允许上传的文件大小的最大值
	// upload.setSizeMax( maxFileSize );

	try {
	    // 解析请求，获取文件项
	    List fileItems = upload.parseRequest(request);
	    // 处理上传的文件项
	    Iterator i = fileItems.iterator();
	  //保存上传的内容
	    List<List<Double>> pointlist = new ArrayList<>();
	    List<Double> ls = new ArrayList<>();
		
	    while (i.hasNext()) {
		FileItem fi = (FileItem) i.next();
		if (!fi.isFormField()) {
		    // 获取上传文件的参数
		    String fileName = fi.getName();
		    // 写入文件
		    if (fileName.lastIndexOf("\\") >= 0) {
			file = new File(
				filePath
					+ fileName.substring(fileName
						.lastIndexOf("\\")));
		    } else {
			file = new File(
				filePath
					+ fileName.substring(fileName
						.lastIndexOf("\\") + 1));
		    }
		    fi.write(file);
		    
		    InputStreamReader isr = new InputStreamReader(
			    new FileInputStream(file), "UTF-8");
		    BufferedReader br = new BufferedReader(isr);
		    String s = null;
		    String[] sl;
		  
		    while ((s = br.readLine()) != null) {// 使用readLine方法，一次读一行
//			System.out.println("每一行"+s);
			sl=s.split(":");
			ls.add(Double.parseDouble(sl[0]));
			ls.add(Double.parseDouble(sl[1]));
			ls.add(Double.parseDouble(sl[2]));
			pointlist.add(ls);
			ls=new ArrayList<>();
		    }
		    
		    br.close();
		}
	    }
	    System.out.println(pointlist);
	    session.setAttribute("pointlist", pointlist);
//	    System.out.println(pointlist.get(1));
	} catch (Exception ex) {
	    System.out.println(ex);
	}
    }
}
