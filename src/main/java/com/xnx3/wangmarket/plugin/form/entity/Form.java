package com.xnx3.wangmarket.plugin.form.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import static javax.persistence.GenerationType.IDENTITY;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.Table;

/**
 * 表单反馈
 * @author 管雷鸣
 */
@Entity(name="plugin_form")
@Table(name = "plugin_form", indexes={@Index(name="suoyin_index",columnList="siteid,state")})
public class Form implements java.io.Serializable {

	private Integer id;			//自动编号
	private Integer siteid;		//提交的表单所属站点的id
	private Integer addtime;	//表单提交的时间,10位时间戳
	private Short state;		//状态。 1：已读； 0：未读，默认为0
	private String title;		//表单提交的标题
	
	/**
	 * 信息状态：已读
	 */
	public final static Short STATE_READ = 1;
	/**
	 * 信息状态：未读
	 */
	public final static Short STATE_UNREAD = 0;

	public Form() {
		this.state = STATE_UNREAD;
	}

	@Id
	@GeneratedValue(strategy = IDENTITY)
	@Column(name = "id", unique = true, nullable = false)
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	@Column(name = "siteid", columnDefinition="int(11) comment '提交的表单所属站点的id' default '0'")
	public Integer getSiteid() {
		return siteid;
	}

	public void setSiteid(Integer siteid) {
		this.siteid = siteid;
	}
	
	@Column(name = "addtime", columnDefinition="int(11) comment '表单提交的时间,10位时间戳' default '0'")
	public Integer getAddtime() {
		return addtime;
	}

	public void setAddtime(Integer addtime) {
		this.addtime = addtime;
	}
	
	@Column(name = "title", columnDefinition="char(50) comment '表单提交的标题' default ''")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		String subTitle = null;
		if(title != null){
			if(title.length() > 50){
				subTitle = title.substring(0, 3);
			}else{
				subTitle = title;
			}
		}
		this.title = subTitle;
	}
	
	@Column(name = "state", columnDefinition="tinyint(1) comment '状态。 1：已读； 0：未读，默认为0' default '0'")
	public Short getState() {
		return state;
	}

	public void setState(Short state) {
		this.state = state;
	}


}