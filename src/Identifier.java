package src;

public class Identifier {
	
	private String name;
	private int scope;
	private int idNumber;

	public Identifier(String name, int scope, int idNumber) {
		super();
		this.name = name;
		this.scope = scope;
		this.idNumber = idNumber;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getScope() {
		return scope;
	}
	public void setScope(int scope) {
		this.scope = scope;
	}
	public int getIdNumber() {
		return idNumber;
	}
	public void setIdNumber(int idNumber) {
		this.idNumber = idNumber;
	}
}
