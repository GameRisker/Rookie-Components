package com.gamerisker.controls.renders
{
	public interface IListCell
	{
		function setData(value : Object) : void
		function get data() : Object
		function Destroy() : void
		function set selected(value : Boolean) : void
		function get selected() : Boolean
	}
}