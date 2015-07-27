package com.spark;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.mllib.linalg.Vector;
import org.apache.spark.mllib.linalg.Vectors;
import org.apache.spark.mllib.regression.LabeledPoint;
import org.apache.spark.mllib.tree.DecisionTree;
import org.apache.spark.mllib.tree.model.DecisionTreeModel;
import org.apache.spark.mllib.util.MLUtils;

public class ModelService implements java.io.Serializable {

    public List<List<Double>> getModel(String filePath) {
	SparkConf conf = new SparkConf().setMaster("local").setAppName(
		"DecisionTree");
	JavaSparkContext sc = new JavaSparkContext(conf);
	JavaRDD<LabeledPoint> data = MLUtils.loadLibSVMFile(sc.sc(), filePath)
		.toJavaRDD().cache();// cache重新计算时无需加载
	int numClasses = 6;// label{0,1...numClasses-1},所以numClasses=6，label=0为空集
	HashMap<Integer, Integer> categoricalFeaturesInfo = new HashMap<Integer, Integer>();
	String impurity = "gini";
	int maxDepth = 10;
	int maxBins = 512;
	final DecisionTreeModel model = DecisionTree.trainClassifier(data,
		numClasses, categoricalFeaturesInfo, impurity, maxDepth,
		maxBins);

	System.out.println("Learned classfication tree model:\n" + model);

	// 开始画图
	int Xmax = 1;// x轴实际长度
	int Ymax = 12;// y轴实际长度
	int max = 500;//
	List<Vector> list = new ArrayList<Vector>();
	for (int i = 0; i <= max; i++) {
	    for (int j = 0; j <= max; j++) {
		Double x = 1.0 * Xmax * i / max;// 实际x坐标值
		Double y = 1.0 * Ymax * j / max;// 实际y坐标值
		Vector point = Vectors.dense(x, y, i, j);
		list.add(point);
	    }
	}
	// System.out.println("坐标点：" + list);

	JavaRDD<Vector> example = sc.parallelize(list);
	// System.out.println(example.collect());
	JavaRDD<LabeledPoint> predict = example
		.map(new Function<Vector, LabeledPoint>() {

		    private static final long serialVersionUID = 1L;

		    @Override
		    public LabeledPoint call(Vector point) throws Exception {
			return new LabeledPoint(model.predict(point), point);
		    }
		});
	// System.out.println("预测值：" + predict.collect());

	List<LabeledPoint> listpredict = predict.collect();// 将RDD转为List,所有max*max个点

	Map<Vector, Integer> map = new HashMap<>();// (坐标，值)
	for (LabeledPoint labeledPoint : listpredict) {
	    int x = (int) labeledPoint.features().apply(2);
	    int y = (int) labeledPoint.features().apply(3);
	    int label = (int) labeledPoint.label();
	    Vector point = Vectors.dense(x, y);
	    map.put(point, label);
	}

	List<List<Double>> linelist = new ArrayList<>();// 描线的点集合

	// 排除上下左右一样的点，留下边线
	for (LabeledPoint v : listpredict) {
	    int x = (int) v.features().apply(2);
	    int y = (int) v.features().apply(3);
	    int p = (int) v.label();
	    if (x == 0 || x == max || y == 0 || y == max) {
		continue;
	    }
	    Vector left = Vectors.dense(x - 1, y);
	    Vector right = Vectors.dense(x + 1, y);
	    Vector down = Vectors.dense(x, y - 1);
	    Vector up = Vectors.dense(x, y + 1);
	    Boolean todel = false;
	    if (map.get(left) != null && map.get(left) == p) {
		if (map.get(right) != null && map.get(right) == p) {
		    if (map.get(down) != null && map.get(down) == p) {
			if (map.get(up) != null && map.get(up) == p) {
			    todel = true;
			}
		    }
		}
	    }
	    if (!todel) {
		double a = v.features().apply(0);
		double b = v.features().apply(1);
		double label = v.label();
		List<Double> ls = new ArrayList<>();
		ls.add(a);
		ls.add(b);
		ls.add(label);
		// System.out.println(ls);
		linelist.add(ls);
	    }
	}

//	sc.stop();
	return linelist;
    }
}
