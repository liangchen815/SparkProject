<%@ page language="java" import="java.util.*" contentType="text/html;"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>New Document</TITLE>
</HEAD>

<BODY style="margin: 0px" onload="this.focus()">
	<canvas height="400" width="600"  id="c"
		style="border:1px solid #c3c3c3;"></canvas>
	<script type="text/javascript">
	//onmousemove="pop_alert(event)"
close="true";
var pointArray=<%=session.getAttribute("linelist")%>;
var a_length = pointArray.length;
var c=document.getElementById("c");
var cxt=c.getContext("2d");
//常量保存
var x_max=100;//x轴最大刻度
var y_max=12;//y轴最大刻度
var x_num=10;//x轴10个刻度
var y_num=6;//y轴6个刻度
var margin_top_buttom=c.height*0.2;//距离上下的距离
var margin_left_right=c.width*0.2;//距离左右的距离
var x_avg=(c.width-2*margin_left_right)/x_max;//x轴单位刻度所占像素
var y_avg=(c.height-2*margin_top_buttom)/y_max;//x轴单位刻度所占像素
//常量结束

//绘制 X轴 
cxt.font = "bold 15px Arial";
for (var i = 0; i <=x_num; i++)
{
    var x_line =margin_left_right+(c.width-2*margin_left_right)/x_num * i;
    cxt.moveTo(x_line,margin_top_buttom+10);
    cxt.lineTo(x_line,margin_top_buttom);
	
	cxt.fillText(i*x_max/x_num,x_line-10,margin_top_buttom-10);
	
}
cxt.fillText("泵效（%）",c.width-margin_left_right,margin_top_buttom+12);
//绘制 Y 轴
for (var i=0; i <=y_num; i++)
{
    var y_line =margin_top_buttom+(c.height-2*margin_top_buttom)/y_num*i;
    cxt.moveTo(margin_left_right,y_line);
    cxt.lineTo(margin_left_right+10,y_line);
	if(i!=0){
		cxt.fillText(i*y_max/y_num,margin_left_right-20,y_line+5);
	}

}
cxt.fillText("流压（MPa）",margin_left_right,c.height-margin_top_buttom+20);
//画边框
cxt.moveTo(margin_left_right, margin_top_buttom); 
cxt.lineTo(c.width-margin_left_right, margin_top_buttom); 
cxt.lineTo(c.width-margin_left_right, c.height-margin_top_buttom);
cxt.lineTo(margin_left_right, c.height-margin_top_buttom); 
cxt.lineTo(margin_left_right, margin_top_buttom); 

cxt.fillText("动态控制图",c.width-margin_left_right+20,c.height-margin_top_buttom);
cxt.strokeStyle = "#000";
cxt.stroke();
cxt.beginPath(); 

cxt.fillStyle="#FF8C00";

//数组散点
for (i = 0; i< a_length; i++ )
{   
    var x = margin_left_right+pointArray[i][0]*100*x_avg;
    var y = margin_top_buttom+pointArray[i][1]*y_avg;
	
    cxt.beginPath();
    cxt.arc( x,y,0.5,0,Math.PI*2);
    cxt.closePath();
    cxt.fill();
}
cxt.fillStyle="#B0B0B0";
cxt.font="20px Arial";
cxt.fillText("I",margin_left_right+15*x_avg,margin_top_buttom+3*y_avg);
cxt.fillText("II",margin_left_right+50*x_avg,margin_top_buttom+5*y_avg);
cxt.fillText("III",margin_left_right+70*x_avg,margin_top_buttom+10.5*y_avg);
cxt.fillText("IV",margin_left_right+15*x_avg,margin_top_buttom+9*y_avg);
cxt.fillText("V",margin_left_right+85*x_avg,margin_top_buttom+3*y_avg);
//单点输入
function drawSinglePoint(bengxiao,liuya){
	var p=predict(bengxiao,liuya);
	var x = margin_left_right+bengxiao*100*x_avg;
    var y = margin_top_buttom+liuya*y_avg;
    cxt.fillStyle=color(p);
    cxt.beginPath();
    cxt.arc( x,y,6,0,Math.PI*2);
    cxt.closePath();
    cxt.fill();
  //添加事件响应
  var data = new Array();
  data[0]=bengxiao;
  data[1]=liuya;
  data[2]=p;
  data[3]=3;
	//mouse event  
   c.addEventListener("click", function(e){
	   if (close == "false")
	    {
	        try {
	            document.body.removeChild(document.getElementById("d1"));
	        } catch (e) {}
	    }

	    var x1=e.clientX;
	    var y1=e.clientY + window.pageYOffset;
		var w=(x1-x)*(x1-x)+(y1-y)*(y1-y);
		if (parseInt(w)<parseInt(36)) {
			show_info(data,x,y);
		}
   }, false);  
  	
}

//多点输入
function drawMultiplePoint(){
	var pointlist=<%=session.getAttribute("pointlist")%>;
	var p1=p2=p3=p4=p5=0;
	for (i = 0; i< pointlist.length; i++ )
	{   
		var p=predict(pointlist[i][0],pointlist[i][1]);
		if (p==1) {
			p1=p1+1;
		}else if (p==5) {
			p2=p2+1;
		}else if (p==2) {
			p3=p3+1;
		}else if (p==3) {
			p4=p4+1;
		}else if (p==4) {
			p5=p5+1;
		}
		cxt.fillStyle=color(p);
	    var x = margin_left_right+pointlist[i][0]*100*x_avg;
	    var y = margin_top_buttom+pointlist[i][1]*y_avg;
		
	    cxt.beginPath();
	    cxt.arc( x,y,6,0,Math.PI*2);
	    cxt.closePath();
	    cxt.fill();
	} 
	//添加事件响应
	  var data = new Array();
	//mouse event  
	   c.addEventListener("click", function(e){
		   if (close == "false")
		    {
		        try {
		            document.body.removeChild(document.getElementById("d1"));
		        } catch (e) {}
		    }

		    var x1=e.clientX;
		    var y1=e.clientY + window.pageYOffset;
		    var x,y,w;
		    for (var j = 0; j< pointlist.length; j++ ){
		    	x = margin_left_right+pointlist[j][0]*100*x_avg;
			    y = margin_top_buttom+pointlist[j][1]*y_avg;
			    w=(x1-x)*(x1-x)+(y1-y)*(y1-y);
			    if (parseInt(w)<parseInt(36)) {
			    	data[0]=pointlist[j][0]*100;
			  	  	data[1]=pointlist[j][1];
			  	  	data[2]=predict(pointlist[j][0],pointlist[j][1]);;
			  	 	data[3]=pointlist[j][2];
					show_info(data,x,y);
				}
		    }
	   }, false);  
	var pp=new Array(p1,p2,p3,p4,p5);
	return pp;
} 

function color(p){
	if (p==1) {
		return "#33CC33";//绿色
	}else if (p==2) {
		return "#FFFF00";//黄色
	}else if (p==3) {
		return "#0000CC";//蓝色
	}else if (p==4) {
		return "#990066";//紫色
	}else if (p==5) {
		return "#FF0000";//红色
	}
}

//即时显示
function pop_alert(e){
    if (close == "false")
    {
        try {
            document.body.removeChild(document.getElementById("d1"));
        } catch (e) {}
    }

    var x=e.clientX;
    var y=e.clientY + window.pageYOffset;
	if(x>=margin_left_right && x<=c.width-margin_left_right && y>=margin_top_buttom && y<=c.height-margin_top_buttom){
		var data = new Array();
		var x_data=(x-margin_left_right)/x_avg;
		var y_data=(y-margin_top_buttom)/y_avg;
		data[0]=x_data.toFixed(2);
		data[1]=y_data.toFixed(2);
		var x_2=x_data/100;
		data[2]=predict(x_2,y_data);
		show_info(data,x,y);
	}
}
function show_info(data,x,y){
	if (data=="") {
		return
	}
    var div_object = document.getElementById("d1");
    if(div_object == null){
        var d = document.createElement("div");
        d.style.cssText = "position:absolute;top:"+y+"px;left:"+(x+20)+"px;background:aqua;border: 1px solid;";
        d.id = "d1";
		var state=status(data[2]);
		var well=" ";
		if (data[3]!=null) {
			well="XXXX"+data[3]+"情况如下：<br/>";
		}
        var content = well+"A："+data[0]+"%<br/>B："+data[1]+"MPa<br/>状态："+state;
        d.innerHTML = content;
        document.body.appendChild(d);
        close="false";
    }
}

function status(predict){
	if(predict == 1){
		return "I区";	
	}else if(predict == 2){
		return "III区";
	}else if(predict == 3){
		return "IV区";
	}else if(predict== 4){
		return "V区";
	}else if(predict == 5){
		return "II区";
	}
}

//决策树模型
function predict(x_data,y_data){
  if (x_data <= 0.301116446880226){
   if (y_data <= 4.566302588212505){
    if (y_data <= 4.481816758814645){
     if (x_data <= 0.2921921212404195){
      return 1.0
     }else if (x_data > 0.2921921212404195){
      if (y_data <= 1.736051185834625E-4){
       return 4.0
      }else if (y_data > 1.736051185834625E-4){
       if (y_data <= 0.0679885214187326){
        return 1.0
       }else if (y_data > 0.0679885214187326){
        if (y_data <= 2.37274234163212){
         return 1.0
        }else if (y_data > 2.37274234163212){
         return 1.0
		}
	   }
	  }
	 }
    }else if (y_data > 4.481816758814645){
     if (x_data <= 0.282003578245276){
      if (x_data <= 0.26050031333658896){
       if (x_data <= 0.24949555833249498){
        if (x_data <= 0.02914188189346325){
         return 1.0
        }else if (x_data > 0.02914188189346325){
         return 1.0
		}
       }else if (x_data > 0.24949555833249498){
        return 3.0
	   }
      }else if (x_data > 0.26050031333658896){
       return 1.0
	  }
     }else if (x_data > 0.282003578245276){
      return 3.0
	 }
	}
   }else if (y_data > 4.566302588212505){
    return 3.0
   }
  }else if (x_data > 0.301116446880226){
   if (y_data <= 8.06190854035964){
    if (x_data <= 0.799423177012996){
     if (y_data <= 0.384016766640654){
      if (x_data <= 0.4041516530046825){
       if (y_data <= 0.168171656936804){
        if (x_data <= 0.33984671621586){
         return 5.0
        }else if (x_data > 0.33984671621586){
         return 4.0
		}
       }else if (y_data > 0.168171656936804){
        if (x_data <= 0.3703643831939655){
         return 5.0
        }else if (x_data > 0.3703643831939655){
         return 5.0
		}
	   }
      }else if (x_data > 0.4041516530046825){
       return 4.0
	  }
     }else if (y_data > 0.384016766640654){
      if (y_data <= 7.984299508023545){
       if (x_data <= 0.3703643831939655){
        if (y_data <= 5.88499032544496){
         return 5.0
        }else if (y_data > 5.88499032544496){
         return 3.0
		}
       }else if (x_data > 0.3703643831939655){
        if (y_data <= 1.3681863050100902){
         return 5.0
        }else if (y_data > 1.3681863050100902){
         return 5.0
		}
	   }
      }else if (y_data > 7.984299508023545){
       if (x_data <= 0.6964169173456645){
        if (x_data <= 0.387029124747145){
         return 3.0
        }else if (x_data > 0.387029124747145){
         return 2.0
		}
       }else if (x_data > 0.6964169173456645){
        if (x_data <= 0.7788061751844839){
         return 5.0
        }else if (x_data > 0.7788061751844839){
         return 5.0
		}
	   }
	  }
	 }
    }else if (x_data > 0.799423177012996){
     if (y_data <= 7.984299508023545){
      return 4.0
     }else if (y_data > 7.984299508023545){
      if (x_data <= 0.8186343775807985){
       return 5.0
      }else if (x_data > 0.8186343775807985){
       if (x_data <= 0.8694010984248755){
        return 2.0
       }else if (x_data > 0.8694010984248755){
        if (x_data <= 0.887580637787583){
         return 4.0
        }else if (x_data > 0.887580637787583){
         return 2.0
		}
	   }
	  }
	 }
	}
   }else if (y_data > 8.06190854035964){
    if (x_data <= 0.396488079400107){
     return 3.0
    }else if (x_data > 0.396488079400107){
     if (x_data <= 0.4041516530046825){
      if (y_data <= 11.4889860086877){
       if (y_data <= 10.9161497371913){
        if (y_data <= 10.670259449898449){
         return 2.0
        }else if (y_data > 10.670259449898449){
         return 3.0
		}
       }else if (y_data > 10.9161497371913){
        return 2.0
	   }
      }else if (y_data > 11.4889860086877){
       return 3.0
	  }
     }else if (x_data > 0.4041516530046825){
      return 2.0
	 }
	}
   }
  }
}
</script>
</BODY>
</HTML>