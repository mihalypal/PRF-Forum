import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { User } from '../Model/User';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  //private readonly url: string = 'http://localhost';
  private readonly url: string = 'http://91.214.112.223';

  constructor(private http: HttpClient) { }

  getAll() {
    return this.http.get<User[]>(this.url + ':3000/app/getAllUsers', {withCredentials: true});
  }

  deleteUser(userId: string) {
    return this.http.delete(this.url + `:3000/app/delete_user/${userId}`, {withCredentials: true, responseType: 'text'});
  }
}
