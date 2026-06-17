<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>导入衣服 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .back-btn { color: #666; text-decoration: none; font-size: 14px; }
        .form-box { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 14px; font-weight: bold; color: #333; margin-bottom: 4px; }
        .form-group label .required { color: #ff6b81; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px;
            font-size: 14px; box-sizing: border-box;
        }
        .form-group textarea { height: 60px; resize: vertical; }
        .form-group .hint { font-size: 12px; color: #999; margin-top: 4px; }
        .btn-submit { width: 100%; padding: 12px; background: #ff6b81; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #e8556b; }
        .success-msg { background: #d4edda; color: #155724; padding: 12px; border-radius: 6px; margin-bottom: 16px; display: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>📷 导入衣服</h2>
        <a href="${pageContext.request.contextPath}/wardrobe/list" class="back-btn">← 返回衣橱</a>
    </div>

    <div class="form-box">
        <form action="${pageContext.request.contextPath}/wardrobe/import" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>图片 <span class="required">*</span></label>
                <input type="file" name="image" accept="image/*" required>
                <div class="hint">支持 jpg, png, gif 格式</div>
            </div>

            <div class="form-group">
                <label>名称 <span class="required">*</span></label>
                <input type="text" name="name" placeholder="如：白色T恤" required>
            </div>

            <div class="form-group">
                <label>品类 <span class="required">*</span></label>
                <select name="category" required>
                    <option value="">请选择</option>
                    <option value="上装">上装</option>
                    <option value="下装">下装</option>
                    <option value="连衣裙">连衣裙</option>
                    <option value="外套">外套</option>
                    <option value="鞋">鞋</option>
                    <option value="包">包</option>
                    <option value="配饰">配饰</option>
                </select>
            </div>

            <div class="form-group">
                <label>颜色 <span class="required">*</span></label>
                <select name="color" required>
                    <option value="">请选择</option>
                    <option value="白色">白色</option>
                    <option value="黑色">黑色</option>
                    <option value="红色">红色</option>
                    <option value="蓝色">蓝色</option>
                    <option value="绿色">绿色</option>
                    <option value="黄色">黄色</option>
                    <option value="粉色">粉色</option>
                    <option value="紫色">紫色</option>
                    <option value="棕色">棕色</option>
                    <option value="灰色">灰色</option>
                </select>
            </div>

            <div class="form-group">
                <label>季节 <span class="required">*</span></label>
                <select name="season" required>
                    <option value="">请选择</option>
                    <option value="春">春</option>
                    <option value="夏">夏</option>
                    <option value="秋">秋</option>
                    <option value="冬">冬</option>
                    <option value="四季">四季</option>
                </select>
            </div>

            <div class="form-group">
                <label>风格</label>
                <select name="style">
                    <option value="">请选择（选填）</option>
                    <option value="通勤">通勤</option>
                    <option value="街头">街头</option>
                    <option value="约会">约会</option>
                    <option value="运动">运动</option>
                    <option value="度假">度假</option>
                </select>
            </div>

            <div class="form-group">
                <label>品牌</label>
                <input type="text" name="brand" placeholder="选填">
            </div>

            <div class="form-group">
                <label>备注</label>
                <textarea name="note" placeholder="如：面料偏厚，很百搭"></textarea>
            </div>

            <button type="submit" class="btn-submit">✅ 保存到衣橱</button>
        </form>
    </div>
</div>
</body>
</html>