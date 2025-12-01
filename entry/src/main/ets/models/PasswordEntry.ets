export class PasswordEntry {
  id: string;
  name: string;
  password: string;
  createdAt: string;

  constructor(id: string, name: string, password: string, createdAt: string) {
    this.id = id;
    this.name = name;
    this.password = password;
    this.createdAt = createdAt;
  }
}