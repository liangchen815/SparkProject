package com.spark;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ModelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private String path, filePath;
    private List<List<Double>> linelist;

    @Override
    public void init() {
	// 获取文件将被存储的位置
	path = getServletContext().getInitParameter("file-upload");
	;
	System.out.println(path);
    }

    @Override
    protected void doGet(HttpServletRequest request,
	    HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request,
	    HttpServletResponse response) throws ServletException, IOException {
	request.setCharacterEncoding("UTF-8");
	HttpSession session = request.getSession();
	try {
	    String fileName = "";
	    if (session != null) {
		fileName = (String) session.getAttribute("fileName");
		if (fileName != null) {
		    if (fileName.lastIndexOf("\\") >= 0) {
			filePath = path
				+ fileName
					.substring(fileName.lastIndexOf("\\"));
		    } else {
			filePath = path
				+ fileName
					.substring(fileName.lastIndexOf("\\") + 1);
		    }
		    
		    linelist = new ModelService().getModel(filePath);
		    session.setAttribute("linelist", linelist);
		    request.getRequestDispatcher("analysis.jsp").forward(request, response);
		} else {

		}
	    }
	} catch (Exception e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
    }

}
