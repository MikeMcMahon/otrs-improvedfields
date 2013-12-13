"use strict"

var ImprovedFields = ImprovedFields || {};

ImprovedFields.TabularField = (function (TargetNS) {
	
	TargetNS.Clean = function(parentId) {
		// Fix the ids
		var id = 0;
		var parent = this;
		_loopChildren(parentId + "_RowData", function(rowIndex, rowObj) {
			if ($(rowObj).attr("id").indexOf("TemplateRow") < 0) {
				_loopChildren($(rowObj).attr("id"), function(colIndex, colObj) {
					var id = $(colObj).attr("id") || "";
					if (id.indexOf("RemoveValue") < 0) {
						var o = $(colObj).attr("id").lastIndexOf("_") + 1;
						var b = $(colObj).attr("name").lastIndexOf("_") + 1;
						$(colObj).attr("id", $(colObj).attr("id").substring(0,o) + rowIndex);
						$(colObj).attr("name", $(colObj).attr("name").substring(0,b) + rowIndex);
					}
				});
				$(rowObj).attr("id", parentId + "_" + rowIndex + "_Row");
			}
		});
	};

	TargetNS.Update = function(parentId) {
		var currentValue = $("#" + parentId).val(function(index, value) {
			var value = {};

			_loopChildren(parentId + "_RowData", function(rowIndex, rowObj) {
				var id = $(rowObj).attr("id") || "";
				if (id.indexOf("TemplateRow") < 0) {
					var rowDataCheck = '';

					// Here we loop the children and build the json to be passed to the backend
					_loopChildren($(rowObj).attr("id"), function(colIndex, colObj) {
						var colId = $(colObj).attr("id");
						if (colId.indexOf("RemoveValue") < 0) {
							value["ROW_" + rowIndex] = value["ROW_" + rowIndex] || {};
							var colName = 
								$(colObj).attr("id")
								.replace(parentId + "_", '');
							colName = colName
								.substring(0, colName.lastIndexOf("_"));
							value["ROW_" + rowIndex][colName] = value["ROW_" + rowIndex][colName] || {};
							value["ROW_" + rowIndex][colName] = $(colObj).children("input:first").val();

							rowDataCheck += $(colObj).children("input:first").val();
						}
					})
					// remove them pesky empty rows
					if (rowDataCheck == '' || rowDataCheck === undefined) {
						delete value["ROW_" + rowIndex];
					}
				}
			});
			return JSON.stringify(value);
		});
	};
	
	TargetNS.RemoveValue = function(obj) {
		$(obj).parent().remove();
	};
	
	TargetNS.Bind = function(parentId) {
		// Binds required actions to keep everything in sync... 
		$("#" + parentId + "_RowData")
		.children("tr")
		.children("td").children("button").each(function(index, object) {
			$(object).click(function(event) {
				ImprovedFields.TabularField.RemoveValue($(object).parent());
				ImprovedFields.TabularField.Clean(parentId);
				ImprovedFields.TabularField.Update(parentId);
			})
		});
		$("#" + parentId + "_RowData")
		.children("tr")
		.children("td").children("input").each(function(index, object) {
			$(object).keypress(function(obj) {
				ImprovedFields.TabularField.Update(parentId);
			});
			$(object).keydown(function(obj) {
				ImprovedFields.TabularField.Update(parentId);
			});
			$(object).keyup(function(obj) {
				ImprovedFields.TabularField.Update(parentId);
			});
			$(object).change(function(obj) {
				ImprovedFields.TabularField.Update(parentId);
			});
		});
	}
	
	TargetNS.AddValue = function(parentId) {
		// copy the template
		return $("#" + parentId + "_TemplateRow")
		.clone(false) // get the event handlers
		.attr("id", "")
		.appendTo(
			$("#" + parentId + "_RowData")
		)
		.show();
	};
	
	
	function _loopChildren(parentId, callback) {
		$("#" + parentId)
		.children()
		.each(function(index, obj) {
			callback(index, obj)
		});
	}
	
	return TargetNS;
}(ImprovedFields.TabularField || {}));
