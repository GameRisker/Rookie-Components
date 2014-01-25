package com.gamerisker.controls.renders
{
	/**
	 * List 的 渲染接口
	 * @author YangDan
	 * 
	 */	
	public interface IListCell
	{
		function setData(value : Object) : void
		function get data() : Object
		function destroy() : void
		function set selected(value : Boolean) : void
		function get selected() : Boolean
	}
}