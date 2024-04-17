// ignore_for_file: void_checks

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/format_mask.dart';

// ignore: must_be_immutable
class ListViewCard extends StatelessWidget {
  ListViewCard({
    super.key,
    required this.items,
    required this.dialogs,
    required this.fieldsData,
    required this.viewModel,
    required this.onReloadData,
    validActionsList,
    addFunction,
    iconCard,
    fieldsSubtitleData,
    List<PopupMenuEntry<dynamic>>? actions,
  }) {
    if (actions != null) {
      appendActions = true;
      this.actions.addAll(actions);
    }
    if (addFunction != null) {
      this.addFunction = addFunction;
    }
    if (validActionsList != null) {
      this.validActionsList = validActionsList;
    }
    if (iconCard != null) {
      this.iconCard = iconCard;
    }
    if (fieldsSubtitleData != null) {
      this.fieldsSubtitleData = fieldsSubtitleData;
    }
  }

  final Function() onReloadData;
  final List<dynamic> items;
  late String fieldsData;
  late List<dynamic> validActionsList = [];
  late List<PopupMenuEntry<dynamic>> actions = [];
  late dynamic dialogs;
  late dynamic viewModel;
  late String fieldsSubtitleData = '';
  var appendActions = false;
  // ignore: avoid_init_to_null
  late Function? addFunction = null;
  var iconCard = Icons.person_outline;
  final sharedPrefres = locator.get<SharedPreferences>();

  Widget renderRowValue(dynamic data, String? key) {
    String value;
    if (data is DateTime) {
      value = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    } else {
      if (data == null) {
        value = '-';
      } else {
        if (data is String) {
          value = data.toString();
          if (key == 'client_tax_identifier_tax_id') {
            value = FormatMask().formated(value);
          }
          if (key == 'cpf_cnpj') {
            value = FormatMask().formated(value);
          }
        } else if (data is bool) {
          value = data == true ? 'Sim' : 'Não';
        } else if (data is Enum) {
          value = data.name.replaceAll('_', ' ');
        } else {
          var dataString = jsonEncode(data);
          value = jsonDecode(dataString)[key].toString();
          if (key == 'cpf_cnpj') {
            value = FormatMask().formated(jsonDecode(dataString)[key].toString());
          }
        }
      }
    }
    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black.withOpacity(0.8),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Map<String, dynamic>> getGrantURLs(
    List<RouteApiDto> routes,
    List<dynamic> urls,
    bool checkRoutes,
  ) {
    List<Map<String, dynamic>> grantURLs = [];
    if (checkRoutes) {
      for (var urlCompare in urls) {
        var index = routes.indexWhere((route) => urlCompare['url'].contains(route.url) && urlCompare['method'].contains(route.method.name));
        if (index >= 0) {
          grantURLs.add({'url': routes[index].url, 'method': routes[index].method.name});
        }
      }
    } else {
      for (var urlCompare in urls) {
        var index = routes.indexWhere((route) => urlCompare['url'].contains(route.url));
        if (index >= 0) {
          grantURLs.add({
            'url': routes[index].url,
          });
        }
      }
    }
    return grantURLs;
  }

  List<PopupMenuEntry<dynamic>> validAction(
    List<RouteApiDto> routes,
    List<dynamic> actions,
    BuildContext context,
  ) {
    routes.sort((a, b) => a.url.compareTo(b.url));
    List<PopupMenuEntry<dynamic>> actionsBtn = [];
    List<Map<String, dynamic>> grantURLs = getGrantURLs(
      routes,
      actions
          .map(
            (v) => {
              'url': v['backendUrl'],
              'method': v['method'],
            },
          )
          .toList(),
      true,
    );
    for (var rota in grantURLs) {
      int itemIndex = actions.indexWhere((v) => v['backendUrl']!.contains(rota['url']) && v['method']!.contains(rota['method']));
      if (itemIndex >= 0 && actions[itemIndex]['method'] == 'POST') {
        actionsBtn.add(
          PopupMenuItem<dynamic>(
            value: {'action': onAddEntity, 'type': 'ADD'},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adicionar novo",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                Icon(
                  Icons.add,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        );
      } else if (itemIndex >= 0 && actions[itemIndex]['method'] == 'PUT') {
        actionsBtn.add(
          PopupMenuItem<dynamic>(
            value: {'action': onEditEntity, 'type': 'EDIT'},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Editar",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        );
      } else if (itemIndex >= 0 && actions[itemIndex]['method'] == 'DELETE') {
        actionsBtn.add(
          PopupMenuItem<dynamic>(
            value: {'action': onChangeActive, 'type': 'ACTIVE'},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Alterar status",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                Icon(
                  Icons.change_circle,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        );
      } else if (itemIndex >= 0 && actions[itemIndex]['method'] == 'GET') {
        actionsBtn.add(
          PopupMenuItem<dynamic>(
            value: {'action': onSeeInfoData, 'type': 'DETAIL'},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Visualizar informações",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 18,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        );
      }
    }
    return actionsBtn;
  }

  void onAddEntity() async {
    if (addFunction != null) {
      var result = await addFunction!();
      if (result != null && result == true) {
        onReloadData();
      }
    } else {
      var result = await dialogs.addDialog();
      if (result != null && result == true) {
        onReloadData();
      }
    }
  }

  void onEditEntity(entity) {
    var catchEntity = viewModel.catchEntity(entity['id']) as Future;
    catchEntity.then((value) async {
      var result = await dialogs.editDialog(value);
      if (result != null && result == true) {
        onReloadData();
      }
    });
  }

  void onChangeActive(entity, context) async {
    List<Map<String, dynamic>> entities = [
      {
        'id': entity['id'],
        'body': {
          'id': entity['id'],
          'active': !entity['active'],
        }
      },
    ];
    if (entity['active'] == true) {
      var result = await Dialogs(context: context).showConfirmDialog({
        'title_text': 'Inativando itens',
        'title_icon': Icons.person_add_disabled_outlined,
        'message': 'Você tem certeza que deseja executar essa ação?\n${entities.length.toString() + ' itens'.toUpperCase()} serão inativados.'
      });
      if (result != null && result == true) {
        var resultChange = await viewModel.changeActive.invoke(entities: entities);
        Timer(const Duration(milliseconds: 500), () {
          if (resultChange != null && resultChange == true) {
            onReloadData();
          }
        });
      }
    } else {
      var result = await Dialogs(context: context).showConfirmDialog({
        'title_text': 'Ativando itens',
        'title_icon': Icons.person_add_outlined,
        'message': 'Você tem certeza que deseja executar essa ação?\n${entities.length.toString() + ' itens'.toUpperCase()} serão ativados.'
      });
      if (result != null && result == true) {
        var resultChange = await viewModel.changeActive.invoke(entities: entities);
        Timer(const Duration(milliseconds: 500), () {
          if (resultChange != null && resultChange == true) {
            onReloadData();
          }
        });
      }
    }
  }

  void onSeeInfoData(entity) {
    var catchEntity = viewModel.catchEntity(entity['id']) as Future;
    catchEntity.then((value) async {
      var result = await dialogs.infoDataDialog(value);
      if (result != null && result == true) {
        onReloadData();
      }
    });
  }

  initializeTable(BuildContext context) {
    if (actions.isEmpty || appendActions) {
      appendActions = false;
      List<PopupMenuEntry<dynamic>> actionsDefault = [];
      List<String>? routesJson = sharedPrefres.getStringList(CoreUserPreferences.ROUTES)!;
      actionsDefault.addAll(
        validAction(
          routesJson.map<RouteApiDto>((element) => RouteApiDto.fromJson(jsonDecode(element))).toList(),
          validActionsList,
          context,
        ),
      );
      actionsDefault.addAll(actions);
      actions = actionsDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeTable(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: SizedBox(
                height: double.infinity,
                width: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: items[index]['active'] == true ? Colors.transparent : Colors.red,
                  ),
                ),
              ),
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.only(right: 16),
              title: Row(
                children: [
                  Icon(iconCard, color: Theme.of(context).colorScheme.primary,),
                  const SizedBox(
                    width: 10,
                  ),
                  fieldsData.split('.').length == 1
                      ? renderRowValue(items[index][fieldsData], fieldsData)
                      : renderRowValue(items[index][fieldsData.split('.')[0]].toJson()[fieldsData.split('.')[1]], fieldsData.split('.')[1]),
                ],
              ),
              subtitle: fieldsSubtitleData.isNotEmpty
                  ? fieldsSubtitleData.split('.').length == 1
                      ? renderRowValue(items[index][fieldsSubtitleData], fieldsSubtitleData)
                      : renderRowValue(
                          items[index][fieldsSubtitleData.split('.')[0]].toJson()[fieldsSubtitleData.split('.')[1]], fieldsSubtitleData.split('.')[1])
                  : const SizedBox(
                      height: 0,
                    ),
              trailing: Theme(
                data: ThemeData().copyWith(
                  hoverColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                  brightness: Theme.of(context).brightness,
                  colorScheme: Theme.of(context).colorScheme,
                  popupMenuTheme: const PopupMenuThemeData().copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onPrimary,
                    iconColor: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                    surfaceTintColor: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: PopupMenuButton<dynamic>(
                  onSelected: (action) {
                    if (action['type'] == 'ADD') {
                      return action['action']();
                    } else if (action['type'] == 'ACTIVE') {
                      return action['action'](items[index], context);
                    } else {
                      return action['action'](items[index]);
                    }
                    // return action();
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  tooltip: 'Ações avançadas',
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.more_vert_outlined),
                  ),
                  itemBuilder: (BuildContext context) => actions.map<PopupMenuEntry<dynamic>>((action) => action).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
